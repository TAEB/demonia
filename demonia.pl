#!C:\per\bin\perl.exe
#demonia.pl
#0.01 :)

use IO::Socket;
require "botlib.pl";

  $nh_name = "Demonia";
  $nh_password = "********************";
  
  $#xmap=0;
  $search_mode=0;
  $excalibur=0;
  $helm=0;
  $boots=0;
  $body=0;
  $gloves=0;
  $long_sword=1;
  $going_down=0;
  $dagger=1;
  $need_to_pay=0;


  $sock = new IO::Socket::INET(PeerAddr => 'nethack.alt.org',
                               PeerPort => 23,
                               Proto => 'tcp');
  die "Could not create socket: $!\n" unless $sock;
  $sock->blocking(0);

$in = initial_negotiations($sock);
login() if $in == 1;


sub login()
{
  #precondition: at the login screen, ready to log in.
  #postcondition: in game.

  my $response;
  print $response, "\n";
 print "Logging in.", "\n";

  out("l"); #login
  sleep 1;
  #$response = response();
  $response = response();
  print $response, "\n";
  out("$nh_name\n");
   sleep 1;
   $response = response();
   print $response, "\n";
 #  $response = response();
   out("$nh_password\n");
      sleep 1;
$response = response();
   out("p");
      sleep 1;
$response = response();

#until ($response =~ /Shall I pick a character's race, role, gender and alignment for you? [ynq]/i)
#{
# sleep(1);
# print "Waiting for promt for auto pick.\n";
#}

out("n");
sleep(1);
out("v");
sleep(1);
out("h");
sleep(1);
out("l");
$response = response();
print "\n", $response, "\n";
sleep(1);
out("\n");
sleep(1);
$response = response();
#newmap();

#$map1 = $response;
#@map1 = split /.\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $map1);
#$a=0;
#while ($a <= $#map1)
#{
#  print $a, " : ", $map1[$a], "\n";
#  $a++;
#}


out("\n");
$response = response();
print "\n", $response, "\n";
sleep(1);


#newmap();

#exit;
 #die "player not found" if $response !~ /$name/i;
#$response =~ s/\[/\n/g;
$a=0;
$want_to_go=4;
$rand_move=$want_to_go;
while (1)
{

  $good_move=0;
    until ($good_move==1)
  {
    newmap();
	#until ($y_you || $x_you)
	#{
	 # out(";");
	 # #sleep(1);
	#  out(".");
	#  #sleep(1);
	#  newmap();
	#}
    print "XPLR: $#xmap TURN: $a Y: $y_you X: $x_you HP: $hp($hp_max)\n";
    #sleep(1);
	if ($hp<($hp_max/2))
	{
	  $elbereth_now=int(rand(2));
	  $elbereth_now=1;
	  if ($elbereth_now)
	  {
	    out("E-");
	    $response=response();
	    if ($response=~/Do you want to add to the current engraving/)
	    {
	      out("y");
	    }
	    out("\nElbereth\n");
		$good_move=1;
	  }	
	}
	if ($status_line =~ /FoodPois/i || $hp<6)
	{
	     sleep(1);
		 out("#pray\n");
		 sleep(1);
		 out("y");
		 sleep(1);
		 moar();
	}
	
	if ($status_line =~ /weak|faint/i)
	{
	  out('e');
	  $response = response();
	  until ($response =~ /corpse|What do you want to eat|You don't have anything to eat/i)
	  {
	  out("\n");
	  $response = response();
	  }
	  if ($response =~ /corpse/i)
	  {
	    sleep(1);
		out("y");
		sleep(1);
		moar();
	  }
	  elsif ($response =~ /What do you want to eat/i)
	  {
	    sleep(1);
		$foodme=$response;
		$foodme=~s/.+\[([A-Za-z]){1}.+/$1/;
		out("$foodme");
		sleep(1);
		moar();
	  }
	  elsif($response =~ /You don't have anything to eat/ && $status_line =~ /faint/i)
	  {
	    #$praynow=int(rand(11));
		$praynow=1;
		if ($praynow==1)
		{
	     sleep(1);
		 out("#pray\n");
		 sleep(1);
		 out("y");
		 sleep(1);
		 moar();
		}
	  }
	  elsif ($response =~ /There are/)
	  {
	    out("q");
		sleep(1);
	  }
	  
	}
	
		 if ($$$dstairs[$dlvl][$y_you][$x_you]==1 && $going_down)
	 {
	   
	   out(">");
	   $going_down=0;
	   #$response = response();
       #print $response;
	   #sleep(1);
	   #while ($response =~ /--More--/)
       #{
       # out ("\n");
	   # sleep(1);
	   # $response = response();
       #}
		moar();	
		newmap();
	 }
	 if ($lastdlvl!=$dlvl)
	{
	$going_down=0;
	$a = 0;
       $b = 0;
       while ($a<23)
        {
         while ($b<80)
         {
           $$screen[$a][$b]="";
         $b++;
         }
         $b=0;
         $a++;
        }
	   @dstairs2=();
	   $search_mode=0;
	   newmap();
       print "XPLR: $#xmap TURN: $a Y: $y_you X: $x_you XSPOT: $$$xmap[$dlvl][$y_you][$x_you]\n";
       sleep(1);
	}
	
	#old line 420
	search_items();
	shift @items;
	search_monsters();
	shift @monsters;
	search_explore();# if $#xmap<2;
	search_dstairs();
	shift @dstairs;
	search_fountains();
	shift @fountains;
	$rand_move=0;
	#shift @xmap;
	#if (!$hallway)
	#{
	#  search_doors();
	#  shift @doors;
	#}
	
		#if (int(rand(2)))
	#{
    #  #stager around as if drunk
    #  $rand_move=5;
    #  until ($rand_move!=5)
	#  {
    #  $rand_move = int(rand(8))+1;
    #  }
	#}
    #else	
	#{
	#  #go leftish
	#  $rand_move=int(rand(3));
	#  $rand_move=1 if $rand_move==0;
	#  $rand_move=4 if $rand_move==1;
	#  $rand_move=7 if $rand_move==2;
	#}
		if ($$screen[$y_you-1][$x_you-1] =~ /\// 
	 && $$screen[$y_you-1][$x_you] =~ /\-/
     && $$screen[$y_you-1][$x_you+1] =~ /\\/ 	 
	   )
	{
      $rand_move=4;
	  $good_move=1;
	}
	
	#push @items;
	if ($#monsters>0 && $good_move==0 && $rand_move==0)
	{
	  get_monsters(1);
	  if((!$#monsters || $#monsters<1) && $rand_move==0 && $good_move==0)
      { 
	    search_monsters();
	    shift @monsters;
	    get_monsters(5);
      }
      
	  if((!$#monsters || $#monsters<1) && $rand_move==0 && $good_move==0)
      { 
	    search_monsters();
	    shift @monsters;
	    get_monsters(80);
      }	  
	}
	if ($$$items[$dlvl][$y_you][$x_you])
	{
	  pick_up_items();
	}
	if ($need_to_pay)
	{  
	   need_to_pay();
    }
	if ($helm==1 && $rand_move==0 && $good_move==0)
	{
	  wear_helm();
	}
	if ($boots==1 && $rand_move==0 && $good_move==0)
	{
	  wear_boots();
	}
	if ($body==1 && $rand_move==0 && $good_move==0)
	{
	  wear_body();
	}
	if ($gloves==1 && $rand_move==0 && $good_move==0)
	{
	  wear_gloves();
	}
	if ($#items>0 && $rand_move==0 && $good_move==0)
	{
	  get_items(80);
	}
	if ($#xmap>0 && $rand_move==0 && $good_move==0)
	{
	    search_shady_square() if !$$$shady_searched[$dlvl][$y_you][$x_you];
		if ($search_mode)
		{
		 print "Searching cause im in searching mode!!!\n";
		 out("n10s");
         moar();
		}
		elsif($xp>4 && !$excalibur && $long_sword==1)
		{
		  if ($#fountains>0 && $long_sword==1 && !$$$fountains[$dlvl][$y_you][$x_you])
		  { 
		    
		    get_fountains(80);
		  }
		  if ($$$fountains[$dlvl][$y_you][$x_you] && $long_sword==1)
		  {
		    check_long_sword();
			if ($long_sword==1)
			{
		    out("#dip\n");
			sleep(1);
			out("a");
			sleep(1);
			out("y");
			$response = response();
			if ($response =~ /murky/)
			{
			  out("\n");
			  print "GOT EXCALIBUR WOOO!!!!";
			  sleep(2);
			  $excalibur=1;
			  
			}
			out("\n");
           moar();
		   }
		  }
		}
		#get_xmap(1);
        #if(!$#xmap || $#xmap<1)
        #{
	    #  search_explore();
		if ($good_move==0)
		{
		  $rand_move=x1();
		  if (!$rand_move)
		  {
		  #  get_xmap(5);
		  # if ($good_move==0)
		  # {
		  #   search_explore();
		  #   get_xmap(10);
		  # }
		   
		   #if ($good_move==0)
		   #{
		   #  search_explore();
		     get_xmap(80);
		   #}
		  }
		}
        #}	  	  
	}
	
	if ($#dstairs>0  && $rand_move==0 && $good_move==0)
	{
	  $going_down=1;
	  get_dstairs(80);
	}
	
	if ($status_line =~ /blind/i && $rand_move==0 && $good_move==0)
	{
	  $good_move=1;
	  $rand_move=".";
	}
	
	#if ($#doors>0 && (!$#monsters || $#monsters<1) && (!$#items || $#items<1) && (!$#xmap || $#xmap<1))
     if(0)
	{
	
	print "DOORS : ", $doors[0], ",", $doors[1], ",", $doors[2], "\n";
      #$y_test_move=$y_you;
	  #$x_test_move=$x_you;
      $close=0;
	  until ($#doors<1 || $close==1)
	  {
	  $door_move_y = $y_you - $doors[0];
	  $door_move_x = $doors[1] - $x_you;
	  if ($door_move_y>5 or $door_move_y<-5 or $door_move_x>5 or $door_move_x<-5)
	  {
	    print "DOOR TO FAR, deleting\n";
		shift @doors;
		shift @doors;
		#sleep(1);
	  }
	  else { $close=1;}
	  
	  }
	  
	  if ($close)
	  {
	    if ($door_move_y>0)
	    {
	      $rand_move=8;
		}
	    elsif ($door_move_y<0)
	    {
	      $rand_move=2;
	    }
	    elsif ($door_move_y==0)
	    {
	      if ($door_move_x>0)
	      {
	        $rand_move=6;
	      }
	      elsif ($door_move_x<0)
	      {
	      $rand_move=4;
	      }
		  elsif ($door_move_x==0)
	      {
		    shift @doors;
		    shift @doors;
		    print "In doorway.\n";
		    #out(",");
		    sleep(1);
		  }
		} 
		if ($response=~/That door is closed|You bump into a door/i)
		  {
		    out("o");
			out("$rand_move");
			moar();
		  }
		 elsif ($response=~/lock/)
		  {
		    out("k");
			out("$rand_move");
			moar();

		  }
	  }
	}
	
	if((!$#items || $#items<1) && (!$#monsters || $#monsters<1) && (!$#doors || $#doors<1) && (!$#xmap || $#xmap<1) && (!$#dstairs || $#dstairs<1))
	{
	  $search_mode=2;
	  kill_xmap();
	  print "SEARCHING MODE ACTIVATED!\n";
	  sleep(1);
	}
	
	
	if(((!$#items || $#items<1) && (!$#monsters || $#monsters<1) && (!$#doors || $#doors<1) && (!$#xmap || $#xmap<1) && (!$#dstairs || $#dstairs<1) && $good_move==0) || $rand_move==0)
	{
	print "GOINGRANDOMOHYEAH!";
	sleep(1);
	 #  #stager around as if drunk
      $rand_move=5;
      until ($rand_move!=5)
	  {
        $rand_move = int(rand(8))+1;
		$rand_move1 = $rand_move;
      }
	  
	  $move_good = check_move($rand_move);
	$good_move=1 if !$move_good;
	$rand_move1 = $rand_move;
	
	while (!$good_move)
	{
	  if ($rand_move1==4)
	  {
	    $rand_move=7;
	  }
	  elsif ($rand_move1==7)
	  {
	    $rand_move=8;
	  }
	  elsif ($rand_move1==8)
	  {
	    $rand_move=9;
	  }
	  elsif ($rand_move1==9)
	  {
	    $rand_move=6;
	  }
	  elsif ($rand_move1==6)
	  {
	    $rand_move=3;
	  }
	  elsif ($rand_move1==3)
	  {
	    $rand_move=2;
	  }
	  elsif ($rand_move1==2)
	  {
	    $rand_move=1;
	  }
	  elsif ($rand_move1==1)
	  {
	    $rand_move=4;
	  }
	  $move_good = check_move($rand_move);
	  $good_move=1 if !$move_good;
	  $rand_move1 = $rand_move;
	}
	  
	  
	}
	#$move_good = check_move($rand_move);
	#$good_move=1 if !$move_good;
	#$rand_move1 = $rand_move;
	
	 
	
   
	
	}
	
  
  print "MOVING $rand_move\n";
  out("$rand_move") if $rand_move!=0;
  #sleep(1);
#  $response2 = response();
#  $response = $response2;
#  print $response2;
#  while ($response2 =~ /--More--/)
#  {
#    out ("\n");
#	$response2 = response();
#	$response = $response . $response2;
#	print $response, "\n";
#	sleep(1);
#  }
$response=moar();
print "\n -###---- \n $response \n---###--\n";
   if ($response=~/Do you want your possessions identified|Do you want to see what you had when you died|Do you want to see your attributes/)
  {
     for ($i=0;$i<10;$i++)
	 {
	 sleep(2);
	 out("y");
	 sleep(2);
	 out(" ");
	 }
	 exit;
  }
  if ($response=~/You feel more confident in your/)
  {
     out("#enhance\n");
	 sleep(2);
	 out("a");
	 sleep(2);
	 moar();
  }
  if ($response=~/welcome/)
  {
     $$$shops[$dlvl][$y_you][$x_you]=1;
  }
  if ($response=~/You are carrying too much to get through/)
  {
     $$$doors[$dlvl][$y_you][$x_you]=1;
  }
   if ($response=~/Really attack/)
  {
     #death wish
     out("y");
	 sleep(1);
  }
     if ($response=~/Call/)
  {
     #death wish
     out("\n");
	 sleep(1);
  }
# print "\n -&&&&&-- \n $response \n--&&&&&--\n";
# if ($response =~ /You see here|Things|There are several objects here|There are many objects here/i)# && $$$useless_items[$dlvl][$y_you][$x_you]!=1)
#	      {
#		  newmap();
#		  pick_up_items();
#		    
#		  
#		  }

 if ($response=~/That door is closed|You bump into a door/i)
		{
		    out("o");
			out("$rand_move");
		    sleep(1);
	        $response = response();
			print $response, "\n";
		    if ($response=~/lock/)
		    {
		      out("k");
			  out("$rand_move");
		    }
			if ($response =~ /no hands/i)# && $$$useless_items[$dlvl][$y_you][$x_you]!=1)
	      {
		  out(".");
		    moar();
		  
		  }
		}

		  if ($response=~/destroy/)
		{
		    #out("o");
			#out("$rand_move");
			$$$bad_corpse[$dlvl][$y_test_move][$x_test_move]=1;
		    print "\nkILLED ME A ZOMBIE!\n";
			#sleep(1);
	        
		}
		
  #$a++; #????????????

  moar();
   #newmap();
  }
  #sleep(60);
  exit;

}



sub out($)
{
  my $line = shift;
  print $sock $line;
  return;

}

sub newmap()
{

#out("O     ");
#out("\022");
my $response = response();

out("\x12");
 $response = response();
 print $response, "\n";
  
my $a;

$y_you=0;
$x_you=0;
$lastdlvl=$dlvl;

#clear the screen damnit!
$a=0;
while ($a<=23)
{
$b=0;
while ($b<=80)
{
  $$screen[$a][$b]="";
  $b++;
}
$a++;
}


$map1 = $response;
$map1 =~ s/\x1b\[C|\[C\x8/ /g;
$map1 =~ s/\x1b\[A|\[A\x8//g;
$map1 =~ s/\x1b\[K|\[K\x8//g;
#$map1 =~ s/\x1b\[[A-Z]|\[[A-Z]\x8//g;
$map1 =~ s/\x1b\[33m(\%?)\-|\x8\[33m(\%?)\-|\x1b\[33m(\%?)\||\x8\[33m(\%?)\|/$1\+/g;
$map1 =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
$map1 =~ s/[\x1b\x8\xd]//g;

@map1 = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $map1);
$a=0;
while ($a <= $#map1)
{
  print $a, " : ", $map1[$a], "\n";
  $a++;
}

$vartmp = "";
$vartmp2 = "";
@map2=@map1;
$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
return if $vartmp !~ /^Dlvl/;
$status_line=$vartmp;
$dlvl=$status_line;
$dlvl=~ s/^Dlvl:(\d+).+/$1/;
$xp=$status_line;
$xp=~ s/.+Xp:(\d+).+|.+Exp:(\d+).+/$1/;
#$status_line=~s/.+Dlvl//;
$hp=$status_line;
$hp=~s/.+HP\:(\d+)\(.+/$1/g;
$hp_max=$status_line;
$hp_max=~s/.+HP\:\d+\((\d+)\).+/$1/g;
#print "DLVL : $dlvl";

$a=0;
#while ($a <= $#map1 && $map1[$a] != 23) #### 23??
while ($a <= $#map1 && $map1[$a] != 24)
{
$b=0;
$some_length = length($map1[$a+2]);
$Y=$map1[$a];
$X=$map1[$a+1];
while ($b <= $some_length)
{
$tile = substr($map1[$a+2], $b, 1);
$$screen[$Y][$X+$b]=$tile;
# if ($$screen[$Y][$X+$b] eq '@')
# {
#   $y_you=$Y;
#   $x_you=$X+$b;
#   $$$xmap[$dlvl][$y_you][$x_you]=2;
# }
$b++;
}
#$$screen[$map1[$a]][$map1[$a+1]]=$map1[$a+2];
$a+=3;
}

if ($map1[$#map1-1]<24 && $map1[$#map1-1]>2 && $map1[$#map1]<80 && $map1[$#map1]>0)
{
 $y_you=$map1[$#map1-1];
 $x_you=$map1[$#map1];
 $$$xmap[$dlvl][$y_you][$x_you]=2;
}

$a=0;
while ($a<=23)
{
$b=0;
while ($b<=80)
{
   if ($y_you == $a && $x_you == $b)
   {
    # $y_you=$a;
    # $x_you=$b;
     print '@';
   }
 #if ($$screen[$a][$b] or ($y_you == $a && $x_you == $b))
 elsif ($$screen[$a][$b])
 {
 
      #print $$screen[$a][$b], ord($$screen[$a][$b]);
	  print $$screen[$a][$b];
  
 }
 else
 {
   print " ";
 }
 print "\n" if $b==80;
$b++;
}
$a++;
}


#########

if (!$y_you || !$x_you)
{
      out(";");
	 # #sleep(1);
	  out(".");
$response = response();
 print $response, "\n";

$map1 = $response;
$map1 =~ s/\x1b\[C|\[C\x8/ /g;
$map1 =~ s/\x1b\[A|\[A\x8//g;
$map1 =~ s/\x1b\[K|\[K\x8//g;
#$map1 =~ s/\x1b\[[A-Z]|\[[A-Z]\x8//g;
$map1 =~ s/\x1b\[33m(\%?)\-|\x8\[33m(\%?)\-|\x1b\[33m(\%?)\||\x8\[33m(\%?)\|/$1\+/g;
$map1 =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
$map1 =~ s/[\x1b\x8\xd]//g;

@map1 = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $map1);
$a=0;
while ($a <= $#map1)
{
  print $a, " : ", $map1[$a], "\n";
  $a++;
}


$vartmp2 = "";
@map2=@map1;
$vartmp2 = shift @map2 until ($vartmp2 =~ /Pick an object/ || $#map2==0);

if ($#map2>0)
{

$y_you=$map2[0];
$x_you=$map2[1];

$$$xmap[$dlvl][$y_you][$x_you]=2;

}

}

}

sub search_items()
{

my $a = 0;
my $b = 0;
$#items=0;
#@items=();

#$$screen[$y_test_move][$x_test_move]

while ($a<23)
{
  while ($b<80)
  {
    if ($$screen[$a][$b] =~ /[\)\%\/\=\?\!\(\$\*\"\[]/ && $$$useless_items[$dlvl][$a][$b]!=1)
	{
      push @items, $a, $b;
	  $$$items[$dlvl][$a][$b]=1;
	}
	elsif ($a != $y_you || $b != $x_you)
	{
	  $$$items[$dlvl][$a][$b]=0;
	}
    $b++;
  }
  $b=0;
  $a++;
}


}

sub search_monsters()
{

my $a = 0;
my $b = 0;
my $fx = 0;
my $fy = 0;
$#monsters=0;
#@monsters=();

#$$screen[$y_test_move][$x_test_move]

while ($a<23)
{
  while ($b<80)
  {
    $$peaceful[$a][$b]=0;  
    $b++;
  }

  $b=0;
  $a++;
}

$a=0;
$b=0;

while ($a<23)
{
  while ($b<80)
  {
    if ($$screen[$a][$b] =~ /[A-Za-z\@\&\':]/  && ($y_you != $a || $x_you != $b))
	{
	  if ($$screen[$a][$b] =~ /\@|n/)
	  {
	    #check if peaceful, tired of dieing to shopkeepers
		$fy=$y_you;
		$fx=$x_you;
		out(";");
		until ($fy==$a)
		{
		  if ($fy<$a)
		  {
		    out("2");
			$fy+=1;
		  }
		  elsif ($fy>$a)
		  {
		    out("8");
			$fy-=1;
		  }
		}
		until ($fx==$b)
		{
		  if ($fx<$b)
		  {
		    out("6");
			$fx+=1;
		  }
		  elsif ($fx>$b)
		  {
		    out("4");
			$fx-=1;
		  }
		}
		$response = response();
	    out(".");
		$response = response();
		if ($response =~ /peaceful|tame|sleep/i)
		{
		  print " ^^^^^^^^^ \n $response \n set $a $b to PEACEful!!!!\n ^^^^^^^^^ \n";
		  #sleep(3);
	      $$peaceful[$a][$b]=1;
		  if (($$screen[$a-1][$b] =~ /\+/
		   || $$screen[$a+1][$b] =~ /\+/
		   || $$screen[$a][$b-1] =~ /\+/
		   || $$screen[$a][$b+1] =~ /\+/)
		   || ($$screen[$a-1][$b] =~ /./ && $$screen[$a-1][$b-1] =~ /\-/ && $$screen[$a-1][$b+1] =~ /\-/)
		   || ($$screen[$a+1][$b] =~ /./ && $$screen[$a+1][$b-1] =~ /\-/ && $$screen[$a+1][$b+1] =~ /\-/)
		   || ($$screen[$a][$b-1] =~ /./ && $$screen[$a-1][$b-1] =~ /\|/ && $$screen[$a+1][$b-1] =~ /\|/)
		   || ($$screen[$a][$b+1] =~ /./ && $$screen[$a-1][$b+1] =~ /\|/ && $$screen[$a+1][$b+1] =~ /\|/)
		   )
		  {
		    $need_to_pay=1;
		  }
		}
		else
		{
		
		  print " ^^^^^^^^^ \n $response\n set $a $b to NOTpeaceful!!!!\n ^^^^^^^^^ \n";
		 # sleep(3);
		  push @monsters, $a, $b;
		}
	  }
	  else
	  {
	  print " ^^^^^^^^^ \n set $a $b to MONSTER!!!!\n ^^^^^^^^^ \n";
	  #sleep(3);
      push @monsters, $a, $b;
	  }
	}
    $b++;
  }
  $b=0;
  $a++;
}

}

sub search_fountains()
{

my $a = 0;
my $b = 0;
$#fountains=0;
#@fountains=();

#$$screen[$y_test_move][$x_test_move]

while ($a<23)
{
  while ($b<80)
  {
    if ($$screen[$a][$b] =~ /\{/)
	{
      push @fountains, $a, $b;
	  $$$fountains[$dlvl][$a][$b]=1;
	}
	elsif ($a != $y_you || $b != $x_you)
	{
	  $$$fountains[$dlvl][$a][$b]=0;
	}
    $b++;
  }
  $b=0;
  $a++;
}

}

sub search_doors()
{

my $a = 0;
my $b = 0;
$#doors=0;
#@doors=();

#$$screen[$y_test_move][$x_test_move]

while ($a<23)
{
  while ($b<80)
  {
    if ($$screen[$a][$b] =~ /\+|\-|\||\./)
	{
      if ($$screen[$a][$b] =~ /\+|\||\./ && $$screen[$a][$b-1] =~ /\-/ && $$screen[$a][$b+1] =~ /\-/)
	  {
	    push @doors, $a, $b;
	  }
	  elsif ($$screen[$a][$b] =~ /\+|\-|\./ && $$screen[$a-1][$b] =~ /\|/ && $$screen[$a+1][$b] =~ /\|/)
	  {
	    push @doors, $a, $b;
	  }
	}
    $b++;
  }
  $b=0;
  $a++;
}


}

sub search_explore()
{

my $a = 0;
my $b = 0;
#$#explore=0;

$total_xmap=$#xmap_total;
@xmap_total=();
@xmap=();

#$$screen[$y_test_move][$x_test_move]

while ($a<23)
{
  while ($b<80)
  {
  
   if ($$screen[$a][$b] =~ /\./ && (($$screen[$a-1][$b] =~ /[\-\|]/
                               && $$screen[$a+1][$b] =~ /[\-\|]/)
							   || ($$screen[$a][$b-1] =~ /[\-\|]/
							   && $$screen[$a][$b+1] =~ /[\-\|]/)))
  {
    $$$xmap[$dlvl][$a][$b] = 1 if $$$xmap[$dlvl][$a][$b] != 2;
  }
  
  if ($$screen[$a][$b] =~ /\./ && ($$screen[$a-1][$b] =~ /\#/
                               || $$screen[$a+1][$b] =~ /\#/
							   || $$screen[$a][$b-1] =~ /\#/
							   || $$screen[$a][$b+1] =~ /\#/))
  {
    $$$xmap[$dlvl][$a][$b] = 1 if $$$xmap[$dlvl][$a][$b] != 2;
  }
  
  if ($$screen[$a][$b] =~ /\./ && (!$$screen[$a-1][$b]
                               || !$$screen[$a+1][$b]
							   || !$$screen[$a][$b-1]
							   || !$$screen[$a][$b+1]))
  {
    $$$xmap[$dlvl][$a][$b] = 1 if $$$xmap[$dlvl][$a][$b] != 2;
  }
  
  if ($$screen[$a][$b] =~ /\./ && (($$screen[$a-1][$b] =~ /[\+\.]/
                               && $$screen[$a-2][$b] =~ /\#/)
							   || ($$screen[$a+1][$b] =~ /[\+\.]/
                               && $$screen[$a+2][$b] =~ /\#/)
							   || ($$screen[$a][$b-1] =~ /[\+\.]/
                               && $$screen[$a][$b-2] =~ /\#/)
							   || ($$screen[$a][$b+1] =~ /[\+\.]/
                               && $$screen[$a][$b+2] =~ /\#/)
							   ))
  {
    $$$xmap[$dlvl][$a][$b] = 1 if $$$xmap[$dlvl][$a][$b] != 2;
  }
  
  
  if ($$screen[$a][$b] =~ /\./ && $$screen[$a-1][$b] =~ /\./
                               && $$screen[$a+1][$b] =~ /\./
							   && $$screen[$a][$b-1] =~ /\./
							   && $$screen[$a][$b+1] =~ /\./ )
							   #&& $search_mode)
  {
    $$$xmap[$dlvl][$a][$b] = 2;
  }
  
    if ($$screen[$a][$b] =~ /[\{\+\#]/ || ($$screen[$a][$b] =~/\./ && $search_mode))
	{
      $$$xmap[$dlvl][$a][$b]=1 if $$$xmap[$dlvl][$a][$b] != 2;
	}
	elsif ($$screen[$a][$b] =~ /\|/ && $$screen[$a][$b-1] =~ /\-/ && $$screen[$a][$b+1] =~ /\-/)
	{
	  $$$xmap[$dlvl][$a][$b]=1 if $$$xmap[$dlvl][$a][$b] != 2;
	}
	elsif ($$screen[$a][$b] =~ /\-/ && $$screen[$a-1][$b] =~ /\|/ && $$screen[$a+1][$b] =~ /\|/)
	{
	  $$$xmap[$dlvl][$a][$b]=1 if $$$xmap[$dlvl][$a][$b] != 2;
	}
    
	if ($$$xmap[$dlvl][$a][$b]==1)
	{
	  push @xmap, $a,$b;
	}
	if ($$$xmap[$dlvl][$a][$b])
	{
	  push @xmap_total, $a,$b;
	}
    $b++;
  }
  $b=0;
  $a++;
}

if ($total_xmap<$#xmap_total && ($total_xmap+15)>$#xmap_total && $search_mode==1)
{

print "\nFOUND SOMETHING NEW, SEARCH MODE OFF!!\n";
sleep(2);
$search_mode=0;

}

if ($search_mode==2)
{

$search_mode=1;

}

}

sub check_move()
{
    #my $rand_move=$_;
	
    if ($rand_move==7)
	{
	  $y_test_move=$y_you-1;
	  $x_test_move=$x_you-1;
	  return 1 if ($$$doors[$dlvl][$y_you][$x_you]==1);
	  return 1 if ($$screen[$y_you][$x_you] =~ /\+/ || $$screen[$y_test_move][$x_test_move] =~ /\+/);
	  return 1 if (($$screen[$y_you][$x_you-1] =~ /[\-\|]/ && 
				   $$screen[$y_you][$x_you+1] =~ /[\-\|]/) ||
				   ($$screen[$y_you-1][$x_you] =~ /[\-\|]/ && 
				   $$screen[$y_you+1][$x_you] =~ /[\-\|]/));
	  return 1 if (($$screen[$y_test_move][$x_test_move-1] =~ /[\-\|]/ && 
				   $$screen[$y_test_move][$x_test_move+1] =~ /[\-\|]/) ||
				   ($$screen[$y_test_move-1][$x_test_move] =~ /[\-\|]/ && 
				   $$screen[$y_test_move+1][$x_test_move] =~ /[\-\|]/));
	}
	elsif ($rand_move==8)
	{
	  $y_test_move=$y_you-1;
	  $x_test_move=$x_you;
#	  return 0 if ($$screen[$y_test_move][$x_test_move] =~ /\|/ && 
#	               $$screen[$y_test_move][$x_test_move-1] =~ /\-/ && 
#				   $$screen[$y_test_move][$x_test_move+1] =~ /\-/);
	}
	elsif ($rand_move==9)
	{
	  $y_test_move=$y_you-1;
	  $x_test_move=$x_you+1;
	  return 1 if ($$$doors[$dlvl][$y_you][$x_you]==1);
	  return 1 if ($$screen[$y_you][$x_you] =~ /\+/ || $$screen[$y_test_move][$x_test_move] =~ /\+/);
	  return 1 if (($$screen[$y_you][$x_you-1] =~ /[\-\|]/ && 
				   $$screen[$y_you][$x_you+1] =~ /[\-\|]/) ||
				   ($$screen[$y_you-1][$x_you] =~ /[\-\|]/ && 
				   $$screen[$y_you+1][$x_you] =~ /[\-\|]/));
	  return 1 if (($$screen[$y_test_move][$x_test_move-1] =~ /[\-\|]/ && 
				   $$screen[$y_test_move][$x_test_move+1] =~ /[\-\|]/) ||
				   ($$screen[$y_test_move-1][$x_test_move] =~ /[\-\|]/ && 
				   $$screen[$y_test_move+1][$x_test_move] =~ /[\-\|]/));
	}
	elsif ($rand_move==4)
	{
	  $y_test_move=$y_you;
	  $x_test_move=$x_you-1;
	  #return 0 if ($$screen[$y_test_move][$x_test_move] =~ /\-/ && 
	  #             (($$screen[$y_test_move-1][$x_test_move] =~ /\|/ && 
	#			   $$screen[$y_test_move+1][$x_test_move] =~ /\|/) ||
#				   ($$screen[$y_test_move-1][$x_test_move] =~ /\-/ && 
#				    $$screen[$y_test_move+1][$x_test_move] =~ /\|/) ||
#				   ($$screen[$y_test_move-1][$x_test_move] =~ /\|/ && 
#				    $$screen[$y_test_move+1][$x_test_move] =~ /\-/)
#				   ));
	}
	elsif ($rand_move==6)
	{
	  $y_test_move=$y_you;
	  $x_test_move=$x_you+1;
#	  return 0 if ($$screen[$y_test_move][$x_test_move] =~ /\-/ && 
#	               (($$screen[$y_test_move-1][$x_test_move] =~ /\|/ && 
#				   $$screen[$y_test_move+1][$x_test_move] =~ /\|/) ||
#				   ($$screen[$y_test_move-1][$x_test_move] =~ /\-/ && 
#				    $$screen[$y_test_move+1][$x_test_move] =~ /\|/) ||
#				   ($$screen[$y_test_move-1][$x_test_move] =~ /\|/ && 
#				    $$screen[$y_test_move+1][$x_test_move] =~ /\-/)
#				   ));
	}
	elsif ($rand_move==1)
	{
	  $y_test_move=$y_you+1;
	  $x_test_move=$x_you-1;
	  return 1 if ($$$doors[$dlvl][$y_you][$x_you]==1);
	  return 1 if ($$screen[$y_you][$x_you] =~ /\+/ || $$screen[$y_test_move][$x_test_move] =~ /\+/);
	  return 1 if (($$screen[$y_you][$x_you-1] =~ /[\-\|]/ && 
				   $$screen[$y_you][$x_you+1] =~ /[\-\|]/) ||
				   ($$screen[$y_you-1][$x_you] =~ /[\-\|]/ && 
				   $$screen[$y_you+1][$x_you] =~ /[\-\|]/));
      return 1 if (($$screen[$y_test_move][$x_test_move-1] =~ /[\-\|]/ && 
				   $$screen[$y_test_move][$x_test_move+1] =~ /[\-\|]/) ||
				   ($$screen[$y_test_move-1][$x_test_move] =~ /[\-\|]/ && 
				   $$screen[$y_test_move+1][$x_test_move] =~ /[\-\|]/));				   
	}
	elsif ($rand_move==2)
	{
	  $y_test_move=$y_you+1;
	  $x_test_move=$x_you;
#	  return 0 if ($$screen[$y_test_move][$x_test_move] =~ /\|/ && 
#	               $$screen[$y_test_move][$x_test_move-1] =~ /\-/ && 
#				   $$screen[$y_test_move][$x_test_move+1] =~ /\-/);
	}
	elsif ($rand_move==3)
	{
	  $y_test_move=$y_you+1;
	  $x_test_move=$x_you+1;
	  return 1 if ($$$doors[$dlvl][$y_you][$x_you]==1);
	  return 1 if ($$screen[$y_you][$x_you] =~ /\+/ || $$screen[$y_test_move][$x_test_move] =~ /\+/);
	  return 1 if (($$screen[$y_you][$x_you-1] =~ /[\-\|]/ && 
				   $$screen[$y_you][$x_you+1] =~ /[\-\|]/) ||
				   ($$screen[$y_you-1][$x_you] =~ /[\-\|]/ && 
				   $$screen[$y_you+1][$x_you] =~ /[\-\|]/));
	return 1 if (($$screen[$y_test_move][$x_test_move-1] =~ /[\-\|]/ && 
				   $$screen[$y_test_move][$x_test_move+1] =~ /[\-\|]/) ||
				   ($$screen[$y_test_move-1][$x_test_move] =~ /[\-\|]/ && 
				   $$screen[$y_test_move+1][$x_test_move] =~ /[\-\|]/));
	}

    if ($$peaceful[$y_test_move][$x_test_move] ==1)
	{
	  return 1;
	}

	
	if ($$shops[$y_test_move][$x_test_move] ==1)
	{
	  return 1;
	}
	
	if ($$screen[$y_test_move][$x_test_move] =~ /\#/)
	{
	  $hallway=1;
	  $#doors=0;
	  return 0;
	}
    elsif ($$screen[$y_test_move][$x_test_move] =~ /[A-Za-z\)\%\/\=\?\!\(\$\*\"\{\.\+\:\@\&\<\>\[\'\`\_]/)
	{
	  $hallway=0;
	  return 0;
	}
	
	if ($$$xmap[$dlvl][$y_test_move][$x_test_move])
	{
	  return 0;
	}
	
	#return 1 if ($$screen[$y_test_move][$x_test_move] =~ /[\|\-\s]/ || !$$screen[$y_test_move][$x_test_move]);
	
	return 1;
}

sub pathway()
{

my $a;
my $b;
my $path_good=1;
my $path_done=0;
my $y=$_[0];
my $x=$_[1];
my $xmap_move_y;
my $xmap_move_x;
   $firstmove=0;
#my @path_past=();
my @path_past_old=@path_past;
my @path_past2=();

$real_y_you = $y_you;
$real_x_you = $x_you;

        $xmap_move_y = $y_you - $y;
	    $xmap_move_x = $x - $x_you;

		 #$y_test_move=$path_past[0]
		 #$x_test_move=$path_past[1]
		 #$peace_check1=check_move();
		 $y_test_move=$path_past[2];
		 $x_test_move=$path_past[3];
		 $peace_check=check_move();
		 #$y_test_move=$path_past[4]
		 #$x_test_move=$path_past[5]
		 #$peace_check3=check_move();
		
		
		if ($path_past[$#path_past-1]==$y && $path_past[$#path_past]==$x
		&& $peace_check==0 && ($path_past[0]==$y_you && $path_past[1]==$x_you))# || $path_past[2]==$y_you && $path_past[3]==$x_you))
		{
		
		  shift @path_past;
		  shift @path_past;
		  
		  $xmap_move_y = $y_you - $path_past[0];
	      $xmap_move_x = $path_past[1] - $x_you;
		  
		  print "SAME PATH!!!!! ", $xmap_move_y, " ", $xmap_move_x, "\n";
		  #sleep(1);
		  
		  if ($xmap_move_y>0)
	    {
		  if ($xmap_move_x>0)
		  {
		    $rand_move=9;
		  }
		  elsif ($xmap_move_x<0)
		  {
		    $rand_move=7;
		  }
		  else
		  {
	        $rand_move=8;
		  }
	    }
	    elsif ($xmap_move_y<0)
	    {
		  if ($xmap_move_x<0)
		  {
		    $rand_move=1;
		  }
		  elsif ($xmap_move_x>0)
		  {
		    $rand_move=3;
		  }
		  else
		  {
	        $rand_move=2;
		  }
	    }
		else
		{
		  if ($xmap_move_x>0)
		  {
		    $rand_move=6;
		  }
		  elsif ($xmap_move_x<0)
		  {
		    $rand_move=4;
		  }
		  else
		  {
	        print "ON PATH SPOT?\n";
			$path_done=1;
  		  }
		}
		  #shift @path_past;
		  #shift @path_past;
		  #print "sending rand_move: ", $rand_move, "\n";
		  $firstmove=$rand_move;
		  return 1;
		}
		else
		{
		  @path_past=();
		}
		
		
		push @path_past, $y_you, $x_you;
		
		print "PATHING... Y: " , $y, " X: ", $x, "\n";
		
	$path_time=0;	
	until ($path_done)
	{
	    $path_time++;
		if ($path_time>1000)
		{
			 $y_you = $real_y_you;
             $x_you = $real_x_you;
			 @path_past=@path_past_old;
			 return 0;
		}
		
	    #print join ".", @path_past;
		#print "\n*****\n";
	    if ($path_good==0)
		{
		  $path_good=1;
		  if ($rand_move==1)
		  {
		    $y_you+=1;
			$x_you-=1;
		  }
		  elsif ($rand_move==2)
		  {
		    $y_you+=1;
			$x_you-=0;
		  }
		  elsif ($rand_move==3)
		  {
		    $y_you+=1;
			$x_you+=1;
		  }
		  elsif ($rand_move==4)
		  {
		    $y_you-=0;
			$x_you-=1;
		  }
		  elsif ($rand_move==6)
		  {
		    $y_you-=0;
			$x_you+=1;
		  }
		  elsif ($rand_move==7)
		  {
		    $y_you-=1;
			$x_you-=1;
		  }
		  elsif ($rand_move==8)
		  {
		    $y_you-=1;
			$x_you-=0;
		  }
		  elsif ($rand_move==9)
		  {
		    $y_you-=1;
			$x_you+=1;
		  }
		  push @path_past, $y_you, $x_you;
		  $xmap_move_y = $y_you - $y;
	      $xmap_move_x = $x - $x_you;
		  if ($firstmove==0)
		  {
		    $firstmove=$rand_move;
		  }
		}
		elsif ($path_good==2)
		{
		  #if ($#path_past==0)
		  #{
		  #  $y_you = $real_y_you;
          #  $x_you = $real_x_you;
		  #  return 0;
		  #}
				
		$x_you = pop @path_past;
		$y_you = pop @path_past;
		
		push @path_past2, $y_you, $x_you;
		
		$x_you = $path_past[$#path_past];
		$y_you = $path_past[$#path_past-1];
		
		$xmap_move_y = $y_you - $y;
	    $xmap_move_x = $x - $x_you;
		
		if ($#path_past==1 && $firstmove!=0)
		  {
		    $firstmove=0;
		  }
		
		}
		
		#make this a lil more random might help a bit
		$rand_pathway=int(rand(2));
		
		if ($xmap_move_y>0)
	    {
		  if ($xmap_move_x>0)
		  {
		    @rand_move=(9,8,6,7,3,4,2,1) if $rand_pathway==0;
			@rand_move=(9,6,8,3,7,2,4,1) if $rand_pathway==1;
		  }
		  elsif ($xmap_move_x<0)
		  {
		    @rand_move=(7,4,8,1,9,2,6,3) if $rand_pathway==0;
			@rand_move=(7,8,4,9,1,6,2,3) if $rand_pathway==1;
		  }
		  else
		  {
	        @rand_move=(8,7,9,4,6,1,3,2) if $rand_pathway==0;
			@rand_move=(8,9,7,6,4,3,1,2) if $rand_pathway==1;
		  }
	    }
	    elsif ($xmap_move_y<0)
	    {
		  if ($xmap_move_x<0)
		  {
		    @rand_move=(1,4,2,3,7,6,8,9) if $rand_pathway==0;
			@rand_move=(1,2,4,7,3,8,6,9) if $rand_pathway==1;
		  }
		  elsif ($xmap_move_x>0)
		  {
		    @rand_move=(3,2,6,1,9,4,8,7) if $rand_pathway==0;
			@rand_move=(3,6,2,9,1,8,4,7) if $rand_pathway==1;
		  }
		  else
		  {
	        @rand_move=(2,1,3,4,6,7,9,8) if $rand_pathway==0;
			@rand_move=(2,3,1,6,4,9,7,8) if $rand_pathway==1;
		  }
	    }
		else
		{
		  if ($xmap_move_x>0)
		  {
		    @rand_move=(6,9,3,8,2,7,1,4) if $rand_pathway==0;
			@rand_move=(6,3,9,2,8,1,7,4) if $rand_pathway==1;
		  }
		  elsif ($xmap_move_x<0)
		  {
		    @rand_move=(4,7,1,8,2,9,3,6) if $rand_pathway==0;
			@rand_move=(4,1,7,2,8,3,9,6) if $rand_pathway==1;
		  }
		  else
		  {
	        print "ON PATH SPOT.\n";
			push @path_past, $y_you, $x_you;
			print join ".", @path_past;
			#sleep(1);
			$path_done=1;
  		  }
		}
		
		#push @rand_move, 4,1,2,3,6,9,8,7;
		$a=0;
		while ($a<=$#rand_move && $path_done!=1)
		{
		  $rand_move=$rand_move[$a];
		  $path_good=check_move();
		  #print "rand_move=", $rand_move, " path_good=", $path_good;
		  if ($path_good==0)
		  {
		  #print "CHECK 1 GOOD!\n";
		  $b=0;
		  while ($b<=$#path_past)
		  {
		    if ($path_past[$b] == $y_test_move &&
                $path_past[$b+1] == $x_test_move)
		    {
		      $path_good=1;
		    }
			$b+=2;
		  }
		  #print "CHECK 2 GOOD!\n" if $path_good==0;
		  $b=0;
		  while ($b<=$#path_past2)
		  {
		    if ($path_past2[$b] == $y_test_move &&
                $path_past2[$b+1] == $x_test_move)
		    {
		      $path_good=1;
		    }
			$b+=2;
		  }
		  #print "CHECK 3 GOOD2GO!\n" if $path_good==0;
         $a=$#rand_move if $path_good==0;		
		}
		 $a++;
		}
		$path_good=2 if $path_good==1 && $path_done!=1;
		

    }
	
          #shift @path_past;
		  #shift @path_past;
		  #shift @path_past;
		  shift @path_past;
		  shift @path_past;

	 $y_you = $real_y_you;
     $x_you = $real_x_you;
}
sub get_items()
{

my $distance=$_[0];
my $neg_distance=$distance-($distance*2);

print "ITEMS : ", $items[0], ",", $items[1], ",", $items[2], "\n";
      #$y_test_move=$y_you;
	  #$x_test_move=$x_you;
	  
	  
	  $close=0;
	  until ($#items<1 || $close==1)
	  {
	  $test1=$items[0];
	  $test2=$items[1];
	  #print "\n***###***\n";
	  #print "$dlvl , $test1 , $test2, $$$useless_items[$dlvl][$test1][$test2]";
	  #print "\n***###***\n";
	  #sleep(2);
	    $item_move_y = $y_you - $items[0];#pring this out tomorrow!
	    print $item_move_y, " = ", $items[0], " - ", $y_you, " DIS: $distance\n";
	    $item_move_x = $items[1] - $x_you;
	    if ($item_move_y>$distance or $item_move_y<$neg_distance or $item_move_x>$distance or $item_move_x<$neg_distance or $$$useless_items[$dlvl][$test1][$test2]==1)
	    {
	      print "ITEM TO FAR, deleting\n";
		  shift @items;
		  shift @items;
	      #sleep(1);
	    }
		elsif ($last_y==$y_you && $last_x==$x_you)
		{
		  $$$useless_items[$dlvl][$y_you][$x_you]=1;
		  shift @items;
		  shift @items;
		}
		else { $close=1; }
	  }
	  
	  #if (($item_move_y==0 && $item_move_x==0) || $y_you == $path_past[$#path_past-1] && $x_you == $path_past[$path_past])
	   
	  if ($close)
	    {
	  
	        $error=1;
			$error=&pathway($items[0],$items[1]);
		    if ($error!=0)
			{
			  $rand_move=$firstmove;
			  $good_move=1;
			}
			else
			{
			  print "PATHING FAILED!Deleting item...\n";
			  shift @items;
		      shift @items;
			  $rand_move=0;
			  $close=0;
			  #sleep(1);
			}
	  
	
		  
		} 
		
	  $last_y=$y_you;
	  $last_x=$x_you;
		
}

sub get_monsters()
{

my $distance=$_[0];
my $neg_distance=$distance-($distance*2);

print "monsterS : ", $monsters[0], ",", $monsters[1], ",", $monsters[2], "\n";
      #$y_test_move=$y_you;
	  #$x_test_move=$x_you;
      
	  $close=0;
	  until ($#monsters<1 || $close==1)
	  {
	  $monster_move_y = $y_you - $monsters[0];#pring this out tomorrow!
	  #print $item_move_y, " = ", $items[0], " - ", $y_you, "\n";
	  $monster_move_x = $monsters[1] - $x_you;
	  if ($monster_move_y>$distance or $monster_move_y<$neg_distance or $monster_move_x>$distance or $monster_move_x<$neg_distance 
	      or ($y_you == $monsters[0] && $x_you == $monsters[1])
		  or ($$peaceful[$monsters[0]][$monsters[1]]==1)
		  )
	  {
	    print "MONSTER TO FAR, deleting\n";
		shift @monsters;
		shift @monsters;
		#sleep(1);
	  }
	  else { $close=1;}
	  }
	  
	  if ($close)
	    {
	  
	        $error=1;
			$error=&pathway($monsters[0],$monsters[1]);
		    if ($error!=0)
			{
			  $rand_move=$firstmove;
			  $good_move=1;
			  if ($$screen[$monsters[0]][$monsters[1]] =~ /e|n/ && $monster_move_y<6 && $monster_move_x<6
			   && ($monster_move_y==0 || $monster_move_x==0 || ($monster_move_y==$monster_move_x))
			  )
			  {
			    $throw_success=0; #fail
			    $throw_success=throw();
				if ($throw_success==0)
				{
				print "THROWING FAILED!Deleting monster...\n";
				if ($$screen[$monsters[0]][$monsters[1]] =~ /e/)
				{
				  #set this shit to friendly so demonia doesnt bash it by accident, melee style walk-attack ftl
				  $$peaceful[$monsters[0]][$monsters[1]]=1
				}
			    shift @monsters;
		        shift @monsters;
			    $rand_move=0;
			    $close=0;
				}
			  }
			  
			}
			else
			{
			  print "PATHING FAILED!Deleting monster...\n";
			  shift @monsters;
		      shift @monsters;
			  $rand_move=0;
			  $close=0;
			  #sleep(1);
			}
	  
	
		  
		} 



}

sub get_xmap()
{

my $distance=$_[0];
my $neg_distance=$distance-($distance*2);

print "XMAPS : ", $xmap[0], ",", $xmap[1], ",", $xmap[2], "\n";
      #$y_test_move=$y_you;
	  #$x_test_move=$x_you;

	  $close=0;
	  until ($#xmap<1 || $close==1)
	  {
	    $xmap_move_y = $y_you - $xmap[0];#pring this out tomorrow!
	    #print $item_move_y, " = ", $items[0], " - ", $y_you, "\n";
	    $xmap_move_x = $xmap[1] - $x_you;
	    if ($xmap_move_y>$distance or $xmap_move_y<$neg_distance or $xmap_move_x>$distance or $item_move_x<$neg_distance)
	    {
	      print "xmap TO FAR, deleting\n";
		  shift @xmap;
		  shift @xmap;
		
	    
	    }
		else { 
		$close=1; 
		}
	  
	  
	 	  
	  	  if ($xmap_move_x==0 && $xmap_move_y==0)
	      {
		    shift @xmap;
		    shift @xmap;
		    print "Picking up xmap.\n";
		    #out("n10s");
		    #sleep(1);
			#$response = response();
			#if ($response=~/Pick up what/)
			#{
			#  out(",\n");
			#  sleep(1);
			#}
		  }
		  elsif ($close)
	      {
		    $error=1;
			$error=&pathway($xmap[0],$xmap[1]);
		    if ($error!=0)
			{
			  $rand_move=$firstmove;
			  $good_move=1;
			}
			else
			{
			  print "PATHING FAILED!Deleting xmap...\n";
			  shift @xmap;
		      shift @xmap;
			  $rand_move=0;
			  $good_move=0;
			  $close=0;
			  #sleep(1);
			}
		  }
		 
		#if ($response=~/That door is closed/)
		#  {
		#    out("o");
		#	out("$rand_move");
		#  }
		#if ($response=~/lock/)
		#  {
		#       out("k");
		#	out("$rand_move");
		#  }
	  }


}

sub get_dstairs()
{

my $distance=$_[0];
my $neg_distance=$distance-($distance*2);

print "DSTAIRS : ", $dstairs[0], ",", $dstairs[1], ",", $dstairs[2], "\n";
      #$y_test_move=$y_you;
	  #$x_test_move=$x_you;

	  $close=0;
	  until ($#dstairs<1 || $close==1)
	  {
	    $item_move_y = $y_you - $dstairs[0];#pring this out tomorrow!
	    print $item_move_y, " = ", $dstairs[0], " - ", $y_you, " DIS: $distance\n";
	    $item_move_x = $dstairs[1] - $x_you;
	    if ($item_move_y>$distance or $item_move_y<$neg_distance or $item_move_x>$distance or $item_move_x<$neg_distance)
	    {
	      print "DSTAIRS TO FAR, deleting\n";
		  shift @dstairs;
		  shift @dstairs;
	      #sleep(1);
	    }
		else { $close=1; }
	  }
	  
	  #if (($item_move_y==0 && $item_move_x==0) || $y_you == $path_past[$#path_past-1] && $x_you == $path_past[$path_past])
	   
	  if ($close)
	    {
	  
	        $error=1;
			$error=&pathway($dstairs[0],$dstairs[1]);
		    if ($error!=0)
			{
			  $rand_move=$firstmove;
			  $good_move=1;
			}
			else
			{
			  print "PATHING FAILED!Deleting STAIRS...\n";
			  shift @dstairs;
		      shift @dstairs;
			  $rand_move=0;
			  $close=0;
			  #sleep(1);
			}
	  
	
		  
		} 
		
}

sub search_dstairs()
{

my $a = 0;
my $b = 0;
$#dstairs=0;

#$$screen[$y_test_move][$x_test_move]

while ($a<23)
{
  while ($b<80)
  {
    if ($$screen[$a][$b] =~ /\>/)
	{
      push @dstairs, $a, $b;
	  #push @dstairs2, $a, $b;
	  $$$dstairs[$dlvl][$a][$b]=1;
	}
    $b++;
  }
  $b=0;
  $a++;
}


}

sub search_shady_square()
{

my $a = 0;
my $b = 0;
my $c = 0;

$real_rand_move=$rand_move;

#$$screen[$y_test_move][$x_test_move]
#if (!$$screen[$y_you][$x_you-1])

@rand_move=(4,6,2,8);
while ($a<=$#rand_move)
{
$rand_move=$rand_move[$a];
$b=check_move();
if ($b==1)
{
$c++;
}

$a++;
}

if ($c==3)
{
    print "FOUND US A SHADY SQUARE!! SEARCHING!\n";
    sleep(1);
    out("n30s");
 	moar();
	$$$shady_searched[$dlvl][$y_you][$x_you]=1;
	$good_move=1;
}

$rand_move=$real_rand_move;

}

sub kill_xmap()
{

my $a = 0;
my $b = 0;
       while ($a<23)
        {
         while ($b<80)
         {
           $$$xmap[$dlvl][$a][$b]="";
         $b++;
         }
         $b=0;
         $a++;
        }


}

sub x1()
{

my $a=0;
my $path_done=0;

 @rand_move=(4,6,2,8,7,3,1,9);
			
		#push @rand_move, 4,1,2,3,6,9,8,7;
		#$$screen[$y_test_move+1][$x_test_move]
		while ($a<=$#rand_move)
		{
		  $rand_move=$rand_move[$a];
		  $path_good=check_move();
		  #print "rand_move=", $rand_move, " path_good=", $path_good;
		  if ($path_good==0 && $$$xmap[$dlvl][$y_test_move][$x_test_move]==1)
		  {
            $good_move=1;		 
		    return $rand_move;
		  }
		  
          $a++;		 
		}

		return 0;
}


sub get_fountains()
{

my $distance=$_[0];
my $neg_distance=$distance-($distance*2);

print "fountains : ", $fountains[0], ",", $fountains[1], ",", $fountains[2], "\n";
      #$y_test_move=$y_you;
	  #$x_test_move=$x_you;
      
	  $close=0;
	  until ($#fountains<1 || $close==1)
	  {
	  $monster_move_y = $y_you - $fountains[0];#pring this out tomorrow!
	  #print $item_move_y, " = ", $items[0], " - ", $y_you, "\n";
	  $monster_move_x = $fountains[1] - $x_you;
	  if ($monster_move_y>$distance or $monster_move_y<$neg_distance or $monster_move_x>$distance or $monster_move_x<$neg_distance)
	  {
	    print "fountains TO FAR, deleting\n";
		shift @fountains;
		shift @fountains;
		#sleep(1);
	  }
	  else { $close=1;}
	  }
	  
	  if ($close)
	    {
	  
	        $error=1;
			$error=&pathway($fountains[0],$fountains[1]);
		    if ($error!=0)
			{
			  $rand_move=$firstmove;
			  $good_move=1;
			}
			else
			{
			  print "PATHING FAILED!Deleting fountains...\n";
			  shift @fountains;
		      shift @fountains;
			  $rand_move=0;
			  $close=0;
			  #sleep(1);
			}
	  
	
		  
		} 



}

sub moar()
{


my $response2 = response();
  #print $response2, "\n";
my $response = $response2;
   #sleep(1);
			  while ($response2 =~ /\-\-More\-\-|Do you want your possessions identified|Do you want to see what you had when you died|\[ynq\]|\[yn\]|you die/i)
             {
			   if ($response2 =~ /Really attack/)
			   {
			     out("y");
				 sleep(1);
			   }
			   elsif ($response2 =~ /\[ynq\]/)
			   {
			     out("q");
				 sleep(1);
			   }
			   elsif ($response2 =~ /\[yn\]/)
			   {
			     out("n");
				 sleep(1);
			   }
               out ("\n");
			   $response = $response2 . $response2;
			   sleep(1);
	           $response2 = response();
			   print $response2, "\n";
			   if ($response2=~/Do you want your possessions identified|Do you want to see what you had when you died/)
  {
     for ($i=0;$i<10;$i++)
	 {
	 sleep(2);
	 out("y");
	 sleep(2);
	 out(" ");
	 }
	 exit;
  }
             }


			 $response=~s/\n//;
			 
			 print "\n ----- \n $response \n-----\n";
			 
			 return $response;
}

sub pick_up_items()
{

my $a = 0;
my $b = 0;
#my $response=join " ", @_;
#my $response;
#$#explore=0;

$response=response();
out(":"); 
$response=moar();
#$response=response();
#$$screen[$y_test_move][$x_test_move]

print "\n***** $response *****\n";
sleep(3);

#$response = response();
shift @items;
		    shift @items;
		    if($response =~ /corpse/ && $status_line !~ /satiated/i && $response !~ /lichen|lizard|cat|dog|bat|kitten|were|yellow mold/i && $$$bad_corpse[$dlvl][$y_you][$x_you]!=1)
			{
			  out("e");
			  sleep(1);
			  out("y");
			  sleep(1);
			  moar();
			}
			else
			{
		      #print "Picking up item.\n";
			  if ($response =~ /you see here/i && ($response =~ /gold|ration|wafer|pancake|pie|cookie|apple|carrot|melon|orange|banana|pear|garlic|wolfsbane|candy/i 
			     || ($response =~ /corpse/i && $response =~ /lichen|lizard/i)
				 || ($response =~ /helm|hard hat|skull cap|leather hat|dented pot/i && $helm==0)
				 || ($response =~ /shoes|boots/i && $boots==0)
				 || ($response =~ /mithril\-coat/i && $body==0)
				 || ($response =~ /gloves/i && $body==0)
				 || ($response =~ /dagger/i && $dagger<10)
				 ))
			  {
			    $helm=1 if $response=~ /helm|hard hat|skull cap|leather hat|dented pot/i;
				$boots=1 if $response=~ /shoes|boots/i;
				$body=1 if $response=~ /mithril\-coat/i;
				$gloves=1 if $response=~ /gloves/i;
				$dagger++ if $response=~ /dagger/i;
		        out(",");
			  }
			  elsif ($response =~ /you see here/i)
			  {
			    
			    $$$useless_items[$dlvl][$y_you][$x_you]=1;
			    print "\n******\n";
				print "$dlvl , $y_you , $x_you , $$$useless_items[$dlvl][$y_you][$x_you]";
				print "\n******\n";
				#sleep(1);
				return;
			  }
		      elsif ($response =~ /There are several objects here|There are many objects here|Things that are here/i)
			  {
			    out(",");
			    $response = response();
			    if ($response=~/Pick up what/)
			    { 
			     #print "\n***!!**\n", $response, "\n***!!**\n";
			     $item_drop = $response;
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $item_drop =~ s/\x1b\[K |\[K\x8 //g;
                 $item_drop =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
                 $item_drop =~ s/[\x1b\x8\xd]//g;
				 @item_drop = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $item_drop);
                 $a=0;
                 while ($a <= $#item_drop)
                 {
                  print $a, " : ", $item_drop[$a], "\n";
                  $a++;
                 }
				
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#item_drop)
				 {
				   if ($item_drop[$a] =~ /^[A-Za-z] \- / && ($item_drop[$a] =~ /gold|ration|wafer|pancake|pie|cookie|apple|carrot|melon|orange|banana|pear|garlic|wolfsbane|candy/i 
				          || ($item_drop[$a] =~ /corpse/i && $item_drop[$a] =~ /lichen|lizard/i)
						  || ($item_drop[$a] =~ /helm|hard hat|skull cap|leather hat|dented pot/i && $helm==0)
						  || ($item_drop[$a] =~ /shoes|boots/i && $boots==0)
						  || ($item_drop[$a] =~ /mithril\-coat/i && $body==0)
						  || ($item_drop[$a] =~ /gloves/i && $gloves==0)
						  || ($item_drop[$a] =~ /dagger/i && $dagger<10)
						  ))
			       {
				    $gloves=1 if $item_drop[$a]=~ /gloves/i;
					$dagger++ if $item_drop[$a]=~ /dagger/i;
				    $body=1 if $item_drop[$a]=~ /mithril\-coat/i;
				    $boots=1 if $item_drop[$a]=~ /shoes|boots/i;
					$helm=1 if $item_drop[$a]=~ /helm|hard hat|skull cap|leather hat|dented pot/i;
				    $item_drop[$a] =~ s/^([A-Za-z]) \- .+/$1/;
					out("$item_drop[$a]");
					sleep(1);
				   }
				   $a++;
				 }
			     out("\n");
			     sleep(1);
				 $response = response();
				 $$$useless_items[$dlvl][$y_you][$x_you]=1;
				}
			    while ($response =~ /--More--/)
                {
                 out("\n");
			     sleep(1);
	             $response = response();
				 out("q") if $response =~ /Continue/;
                }
		      }
			  else
			  {
			    $$$useless_items[$dlvl][$y_you][$x_you]=1;
				return;
              }
            $$$useless_items[$dlvl][$y_you][$x_you]=1;
			return;
			
			}
			$$$bad_corpse[$dlvl][$y_you][$x_you]=1;
			
}

sub wear_helm()
{
my $a=0;
                $helm=2;
                out("i");
			    $response = response();
			    $inventory = $response;
				out("\n");
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $inventory  =~ s/\x1b\[K |\[K\x8 //g;
                 $inventory  =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
                 $inventory  =~ s/[\x1b\x8\xd]//g;
				 @inventory  = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $inventory );
                 $a=0;
                 while ($a <= $#inventory )
                 {
                  print $a, " : ", $inventory [$a], "\n";
                  $a++;
                 }
				#sleep(5);
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#inventory)
				 {
				   if ($inventory[$a] =~ /^[A-Za-z] \- / && $inventory[$a] =~ /helm|hard hat|skull cap|leather hat|dented pot/i && $inventory[$a] !~ /unpaid/i)
				   {
				    $helm=2;
				    $inventory[$a] =~ s/^([A-Za-z]) \- .+/$1/;
					out("W");
					sleep(1);
					out("$inventory[$a]");
					sleep(1);
					$good_move=1;
				   }
				   $a++;
				 }


}

sub wear_boots()
{
my $a=0;
                $boots=2;
                out("i");
			    $response = response();
			    $inventory = $response;
				out("\n");
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $inventory  =~ s/\x1b\[K |\[K\x8 //g;
                 $inventory  =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
                 $inventory  =~ s/[\x1b\x8\xd]//g;
				 @inventory  = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $inventory );
                 $a=0;
                 while ($a <= $#inventory )
                 {
                  print $a, " : ", $inventory [$a], "\n";
                  $a++;
                 }
				#sleep(5);
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#inventory)
				 {
				   if ($inventory[$a] =~ /^[A-Za-z] \- / && $inventory[$a] =~ /shoes|boots/i && $inventory[$a] !~ /unpaid/i)
				   {
				    $helm=2;
				    $inventory[$a] =~ s/^([A-Za-z]) \- .+/$1/;
					out("W");
					sleep(1);
					out("$inventory[$a]");
					sleep(1);
					$good_move=1;
				   }
				   $a++;
				 }


}

sub wear_body()
{
my $a=0;
                $body=2;
                out("i");
			    $response = response();
			    $inventory = $response;
				out("\n");
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $inventory  =~ s/\x1b\[K |\[K\x8 //g;
                 $inventory  =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
                 $inventory  =~ s/[\x1b\x8\xd]//g;
				 @inventory  = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $inventory );
                 $a=0;
                 while ($a <= $#inventory )
                 {
                  print $a, " : ", $inventory [$a], "\n";
                  $a++;
                 }
				#sleep(5);
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#inventory)
				 {
				   if ($inventory[$a] =~ /^[A-Za-z] \- / && $inventory[$a] =~ /mithril-coat/i && $inventory[$a] !~ /unpaid/i)
				   {
				    $body=2;
				    $inventory[$a] =~ s/^([A-Za-z]) \- .+/$1/;
					out("W");
					sleep(1);
					out("$inventory[$a]");
					sleep(1);
					$good_move=1;
				   }
				   $a++;
				 }


}

sub wear_gloves()
{
my $a=0;

                $gloves=2;
                out("i");
			    $response = response();
			    $inventory = $response;
				out("\n");
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $inventory  =~ s/\x1b\[K |\[K\x8 //g;
                 $inventory  =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
                 $inventory  =~ s/[\x1b\x8\xd]//g;
				 @inventory  = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $inventory );
                 $a=0;
                 while ($a <= $#inventory )
                 {
                  print $a, " : ", $inventory [$a], "\n";
                  $a++;
                 }
				#sleep(5);
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#inventory)
				 {
				   if ($inventory[$a] =~ /^[A-Za-z] \- / && $inventory[$a] =~ /gloves/i && $inventory[$a] !~ /unpaid/i)
				   {
				    $gloves=2;
				    $inventory[$a] =~ s/^([A-Za-z]) \- .+/$1/;
					out("W");
					sleep(1);
					out("$inventory[$a]");
					sleep(1);
					$good_move=1;
				   }
				   $a++;
				 }


}

sub check_long_sword()
{

my $a=0;
                $long_sword=0;
				$good_move=0;
                out("i");
				sleep(1);
			    $response = response();
			    $inventory = $response;
				print "***** ",$inventory," *****";
				return if $inventory =~ /Not carrying anything/;
				out("\n");
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $inventory  =~ s/\x1b\[K |\[K\x8 //g;
                 $inventory  =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
                 $inventory  =~ s/[\x1b\x8\xd]//g;
				 @inventory  = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $inventory );
                 $a=0;
                 while ($a <= $#inventory )
                 {
                  print $a, " : ", $inventory [$a], "\n";
                  $a++;
                 }
				#sleep(5);
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#inventory)
				 {
				   if ($inventory[$a] =~ /^[A-Za-z] \- / && $inventory[$a] =~ /long sword/i && $inventory[$a] !~ /weapon in hand/i)
				   {
				    $long_sword=1;
				    $inventory[$a] =~ s/^([A-Za-z]) \- .+/$1/;
					out("w");
					sleep(1);
					out("$inventory[$a]");
					sleep(1);
					$good_move=1;
				   }
				   elsif($inventory[$a] =~ /^[A-Za-z] \- / && $inventory[$a] =~ /long sword/i && $inventory[$a] =~ /weapon in hand/i)
				   {
				    $long_sword=1;
				   }
				   $a++;
				 }


}

sub need_to_pay()
{

my $a=0;

my $response = response();

                
#				$good_move=1;
                out("i");
				sleep(1);
			    $response = response();
			    $inventory = $response;
				print "***** ",$inventory," *****";
				return if $inventory =~ /Not carrying anything/;
				out("\n");
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $inventory  =~ s/\x1b\[K |\[K\x8 //g;
                 $inventory  =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
                 $inventory  =~ s/[\x1b\x8\xd]//g;
				 @inventory  = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $inventory );
                 $a=0;
                 while ($a <= $#inventory )
                 {
                  print $a, " : ", $inventory [$a], "\n";
                  $a++;
                 }
				#sleep(5);
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#inventory)
				 {
				   if ($inventory[$a] =~ /[A-Za-z] \- / && $inventory[$a] =~ /unpaid/i)
				   {
				    print "\nI NEED TO PAY FOR SOMETHING!\n";
					#sleep(2);
				    $need_to_pay=2;
				   }
				   $a++;
				 }

				 if ($need_to_pay==2)
				 {
				 $need_to_pay=0;
				 $response = response();
				 out("p");
				 sleep(1);
			     $response = response();
				 out("y") if $response =~ /Pay\?/;
				 
				 if ($response =~ /have enough money/i)
				 {
				   drop_unpaid_items();
				 }
			     elsif ($response =~ /Itemized billing/i)
				 {
				   out("n");
				   $response=moar();
				   print "\n ---2-- \n $response \n---2--\n";
				   if ($response =~ /have gold enough/i)
				   {
				   print "\n --3--- \n $response \n---3--\n";
				     drop_unpaid_items();
				   }
				   
				 }
				 
				 }
				 else
				 {
				 $need_to_pay=0;
				 }
				 

}

sub drop_unpaid_items()
{

my $a=0;

                $response = response();
                out("i");
				sleep(1);
			    $response = response();
			    $inventory = $response;
				print "***** ",$inventory," *****";
				return if $inventory =~ /Not carrying anything/;
				out("\n");
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $inventory  =~ s/\x1b\[K |\[K\x8 //g;
                 $inventory  =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g;
                 $inventory  =~ s/[\x1b\x8\xd]//g;
				 @inventory  = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $inventory );
                 $a=0;
                 while ($a <= $#inventory )
                 {
                  print $a, " : ", $inventory [$a], "\n";
                  $a++;
                 }
				#sleep(5);
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#inventory)
				 {
				   if ($inventory[$a] =~ /[A-Za-z] \- / && $inventory[$a] =~ /unpaid/i)
				   {
				    #print "\n\n$inventory[$a]\n\n"; 
					#sleep(3);
				    $inventory[$a] =~ s/.*([A-Za-z]) \- .+/$1/;
					out("d");
					sleep(1);
					out("$inventory[$a]");
					print "\n DROPPING $inventory[$a]\n";
					sleep(1);
					$good_move=1;
					moar();
				   }
				   $a++;
				 }

				 $$$useless_items[$dlvl][$y_you][$x_you]=1 if $good_move;

}

sub throw()
{

my $a=0; #counts for while

                $response = response(); #get response from server in case there is any
                out("i"); #show inventory
				sleep(1); #sleep
			    $response = response(); #get response from server
			    $inventory = $response; #doing this to preserve response for some reason
				print "***** ",$inventory," *****"; #inventory response from server
				return 0 if $inventory =~ /Not carrying anything/; #epic fail, dont have any inventory
				out("\n"); #hopefully demonia's inventory is only one page
                 #$item_drop =~ s/\x1b\[C|\[C\x8/ /g;
                 #$item_drop =~ s/\x1b\[A|\[A\x8//g;
                 $inventory  =~ s/\x1b\[K |\[K\x8 //g; #get rid of these telnet chars i dont know what they do
                 $inventory  =~ s/\[\d{1,2}m|\d{1,2}m\x1b//g; #strip colors
                 $inventory  =~ s/[\x1b\x8\xd]//g; #unprintible esc caracters or some shit
				 @inventory  = split /\[(\d{1,2})\;(\d{1,2})H/, ("Y", $1 , "X", $2 , "", $inventory );
				 #split the inventory to look like [0]=y [1]=x [2]=a - dagger, or whatever
                 $a=0; #start the count
                 while ($a <= $#inventory ) #while $a is less than the inventory lines
                 {
                  print $a, " : ", $inventory [$a], "\n"; #print the line number: inventory listing
                  $a++; #add one line to the count
                 }
				#sleep(5);
				 #$vartmp = shift @item_drop until ($vartmp =~ /^/i);
				 #$vartmp = shift @map1 until ($vartmp =~ /^Dlvl/ || $#map1==0);
				 $a=0;
				 while($a<=$#inventory)
				 {
				   if ($inventory[$a] =~ /[A-Za-z] \- / && $inventory[$a] =~ /dagger/i) 
				   {
				    #if this is some sort of dagger
				    #print "\n\n$inventory[$a]\n\n"; 
					#sleep(3);
				    $inventory[$a] =~ s/.*([A-Za-z]) \- .+/$1/; #i think this explains itself
					out("t"); #throw
					sleep(1); #sleep
					out("$inventory[$a]"); #the inventory letter of the first dagger listed in inventory
					out("$rand_move"); #direction the e is in
					print "\n THROWING $inventory[$a]\n"; #this is what im doing now
					sleep(1); #rest here
					$good_move=1; #successful action
					$rand_move=0; #dont move anywhere now
					$dagger--; #now we have 1 less dagger
					moar();  #catch any more prompts
					return 1; #succcessful throw
				   }
				   $a++;
				 }

				 return 0; #if we got here, we failed, epicly

}
