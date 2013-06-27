#!C:\Perl\bin\perl.exe
#botlib.pl
#found this code online when i was having trouble getting spazbot the scorefest bot to work with NAO
#

my $IAC = 255;
my $TEXT = 0;
my $SB = 250;
my $SE = 240;
my $WILL = 251;
my $WONT = 252;
my $DO = 253;
my $DONT = 254;
my $SBIAC = 300; #outside of the normal range..
my $TTYPE = 24;
my $TSPEED = 32;
my $XDISPLOC = 35;
my $NEWENVIRON = 39;
my $IS = 0;
my $GOAHEAD = 3;
my $ECHO = 1;
my $NAWS = 31;
my $STATUS = 5;
my $RFC = 33;

my $sock;
my $telnetmode = $TEXT;
my $subbuf;

sub parse_telnet($)
{
  my $input = shift;
  my $ret = '';
  my $c;

  while ($input)
  {
    if ($telnetmode == $TEXT)
    {
      while ($input && $telnetmode == $TEXT)
      {
        $c = substr($input, 0, 1);

        if (ord($c) == $IAC)
        {
          $telnetmode = $IAC;
        }
        else
        {
          $ret .= $c;
        }
        $input = substr($input, 1);
      }
    }
    elsif ($telnetmode == $IAC)
    {
      while ($input && $telnetmode == $IAC)
      {
        $c = substr($input, 0, 1);

        if (ord($c) == $IAC)
        {
          $ret .= $c;
          $telnetmode = $TEXT;
        }
        elsif (ord($c) == $SB)
        {
          $telnetmode = $SB;
        }
        elsif (ord($c) == $DO)
        {
          $telnetmode = $DO;
        }
        elsif (ord($c) == $DONT)
        {
          $telnetmode = $DONT;
        }
        elsif (ord($c) == $WILL)
        {
          $telnetmode = $WILL;
        }
        elsif (ord($c) == $WONT)
        {
          $telnetmode = $WONT;
        }
        else
        {
          die 'unrecognized negotiation option "'.ord($c).'"';
        }
        $input = substr($input, 1);
      }
    }
    elsif ($telnetmode == $SB)
    {
      while ($input && $telnetmode == $SB)
      {
        $c = substr($input, 0, 1);

        if (ord($c) == $IAC)
        {
          $telnetmode = $SBIAC;
        }
        else
        {
          $subbuf .= $c;
        }
        $input = substr($input, 1);
      }
    }
    elsif ($telnetmode == $DO || $telnetmode == $WILL || $telnetmode == $DONT || $telnetmode == $WONT)
    {
      if ($input)
      {
        $c = substr($input, 0, 1);
        $input = substr($input, 1);

        if (ord($c) == $TTYPE)
        {
          printf $sock "%c%c%c", $IAC, $WILL, $TTYPE;
        }
        elsif (ord($c) == $TSPEED)
        {
          printf $sock "%c%c%c", $IAC, $WONT, $TSPEED;
        }
        elsif (ord($c) == $XDISPLOC)
        {
          printf $sock "%c%c%c", $IAC, $WILL, $XDISPLOC;
        }
        elsif (ord($c) == $NEWENVIRON)
        {
          printf $sock "%c%c%c", $IAC, $WILL, $NEWENVIRON;
        }
        elsif (ord($c) == $GOAHEAD)
        {
          printf $sock "%c%c%c", $IAC, $DO, $GOAHEAD;
        }
        elsif (ord($c) == $ECHO)
        {
          if ($telnetmode == $DO)
          {
            printf $sock "%c%c%c", $IAC, $WILL, $ECHO;
          }
          elsif ($telnetmode == $DONT)
          {
            printf $sock "%c%c%c", $IAC, $WONT, $ECHO;
          }
          else
          {
            printf $sock "%c%c%c", $IAC, $DO, $ECHO;
          }
        }
        elsif (ord($c) == $NAWS)
        {
          printf $sock "%c%c%c", $IAC, $WILL, $NAWS;
          printf $sock "%c%c%c%c%c%c%c%c%c", $IAC, $SB, $NAWS, 0, 80, 0, 24, $IAC, $SE;
        }
        elsif (ord($c) == $STATUS)
        {
          printf $sock "%c%c%c", $IAC, $DO, $STATUS;
        }
        elsif (ord($c) == $RFC)
        {
          printf $sock "%c%c%c", $IAC, $WILL, $RFC;
        }
        else
        {
          die 'unrecognized do/dont/will/wont mode requested/informed: '.ord($c)."\n";
        }

        $telnetmode = $TEXT;
      }
    }
    elsif ($telnetmode == $SBIAC)
    {
      if ($input)
      {
        $c = substr($input, 0, 1);
        $input = substr($input, 1);

        if (ord($c) == $IAC)
        {
          $subbuf .= $c;
          $telnetmode = $SB;
        }
        elsif (ord($c) == $SE)
        {
          $c = substr($subbuf, 0, 1);
          if (ord($c) == $TTYPE)
          {
            printf $sock "%c%c%c%cXTERM%c%c", $IAC, $SB, $TTYPE, $IS, $IAC, $SB;
          }
          elsif (ord($c) == $TSPEED)
          {
            printf $sock "%c%c%cc38400,38400%c%c", $IAC, $SB, $TSPEED, $IS, $IAC, $SB;
          }
          elsif (ord($c) == $NEWENVIRON)
          {
            printf $sock "%c%c%c%c%c%c", $IAC, $SB, $NEWENVIRON, $IS, $IAC, $SB;
          }
          elsif (ord($c) == $XDISPLOC)
          {
            printf $sock "%c%c%c%c%c%c", $IAC, $SB, $XDISPLOC, $IS, $IAC, $SB;
          }
          $telnetmode = $TEXT;
          $subbuf = '';
        }
        else
        {
         # debug("unrecognized subrequest-iac byte: $c. clearing subbuf and returning to text\n");
          $telnetmode = $TEXT;
          $subbuf = '';
        }
      }
    }
    else
    {
      die "unrecognized mode $telnetmode";
    }
  }

  return $ret;
}


sub response()
{
  my ($buf, $ret, $timeout);
  my $recursion = shift;

  print $sock "\xFF\xFA\x05\x01\xFF\xF0"; #iac subnegotiation status send iac endsubnegotiation
  $timeout = 60 + time; #one minute is very generous..

  $ret = '';

  while (time < $timeout)
  {
    $ret .= $buf if recv($sock, $buf, 1024, 0);
  #  sleep 0.1;

#print $ret, "\n";
    if ($ret =~ /\xFF\xFA\x05\x00.*?\xFF\xF0/) #iac subnegotiation status is .* iac endsubnegitiation
    {
	
      $ret = parse_telnet($ret);



 #     if ($ret =~ /--More--/)
  #    {
   #     print $sock "\n";
    #    $ret .= &response(++$recursion); #ampersand exists to bypass (W prototype)
   #   }

    #  $ret =~ s/--More--//g;
      #commented out the timestamp because it was making huge logs...
     # print INLOG #timestamp . 
      #            $ret . "\n" if ($recursion && $loginput);

			#	  print $ret, "\n";
      return $ret;
    }

  }

  die "timed out while waiting for pong";
}

sub initial_negotiations($)
{
  $sock = shift;
  my $buf = '';
  my $recv = '';
  my $timeout = 10 + time;

  while (time < $timeout)
  {
    next unless recv($sock, $recv, 1024, 0);
    $buf .= parse_telnet($recv);
    if ($buf =~ /l\) Login/)
    {
      $response = response(); # (BUG?) for some reason this is necessary.. ugh
      #login();
      return 1;
    }

  }

  die "initial negotiations timed out";
}

return 1;

