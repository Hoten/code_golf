# http://codegolf.stackexchange.com/questions/68621/create-an-ascii-to-hex-table-for-mark-watney

require_relative 'harness.rb'
require 'digest'
require 'differ'

def hardcoded_table
  %q[Dec Hex    Dec Hex    Dec Hex  Dec Hex  Dec Hex  Dec Hex   Dec Hex   Dec Hex  
  0 00 NUL  16 10 DLE  32 20    48 30 0  64 40 @  80 50 P   96 60 `  112 70 p
  1 01 SOH  17 11 DC1  33 21 !  49 31 1  65 41 A  81 51 Q   97 61 a  113 71 q
  2 02 STX  18 12 DC2  34 22 "  50 32 2  66 42 B  82 52 R   98 62 b  114 72 r
  3 03 ETX  19 13 DC3  35 23 #  51 33 3  67 43 C  83 53 S   99 63 c  115 73 s
  4 04 EOT  20 14 DC4  36 24 $  52 34 4  68 44 D  84 54 T  100 64 d  116 74 t
  5 05 ENQ  21 15 NAK  37 25 %  53 35 5  69 45 E  85 55 U  101 65 e  117 75 u
  6 06 ACK  22 16 SYN  38 26 &  54 36 6  70 46 F  86 56 V  102 66 f  118 76 v
  7 07 BEL  23 17 ETB  39 27 '  55 37 7  71 47 G  87 57 W  103 67 g  119 77 w
  8 08 BS   24 18 CAN  40 28 (  56 38 8  72 48 H  88 58 X  104 68 h  120 78 x
  9 09 HT   25 19 EM   41 29 )  57 39 9  73 49 I  89 59 Y  105 69 i  121 79 y
 10 0A LF   26 1A SUB  42 2A *  58 3A :  74 4A J  90 5A Z  106 6A j  122 7A z
 11 0B VT   27 1B ESC  43 2B +  59 3B ;  75 4B K  91 5B [  107 6B k  123 7B {
 12 0C FF   28 1C FS   44 2C ,  60 3C <  76 4C L  92 5C \  108 6C l  124 7C |
 13 0D CR   29 1D GS   45 2D -  61 3D =  77 4D M  93 5D ]  109 6D m  125 7D }
 14 0E SO   30 1E RS   46 2E .  62 3E >  78 4E N  94 5E ^  110 6E n  126 7E ~
 15 0F SI   31 1F US   47 2F /  63 3F ?  79 4F O  95 5F _  111 6F o  127 7F DEL]
end

def line_by_line(computed)
  computed = computed.split("\n")
  hardcoded_table.split("\n").each_with_index do |line, i|
    if line != computed[i] and computed.length > i
      Differ.format = :color
      diff = Differ.diff_by_word(line.bytes.join(', '), computed[i].bytes.join(', ')).to_s
      e = "mismatch on line #{i}: \n(#{line.length})\n#{line}\n(#{computed[i].length})\n#{computed[i]}\n\n#{diff}"
      raise e
    end
  end
end

def test
  output = yield
  puts hardcoded_table, '', output
  line_by_line(output)
  md5 = Digest::MD5.new
  md5.update output
  hash = md5.hexdigest
  hash == '58824a1dd7264c0410eb4d727aec54e1' || hash == '41b6ecde6a3a1324be4836871d8354fe'
end

solution(1) do
  c=%w[NUL SOH STX ETX EOT ENQ ACK BEL BS HT LF VT FF CR SO SI DLE DC1 DC2 DC3 DC4 NAK SYN ETB CAN EM SUB ESC FS GS RS US]
  s="Dec Hex    "*2+"Dec Hex  "*4+" Dec Hex  "*2
  a=128.times.map{|i|"#{i} #{'%.2X'%i} #{c[i]?c[i].ljust(3):i.chr}"}
  a[-1]=a[-1][0..-2]
  x=16.times.map{|i|8.times.map{|j|a[i+j*16].rjust(j<2?10+j :9+j/6)}.join}.join("\n")
  x[-10]=''
  puts s,"#{x}DEL"
end

solution(2) do
  a=128.times.map{|i|"#{i} #{'%.2X'%i} #{'NULSOHSTXETXEOTENQACKBELBS HT LF VT FF CR SO SI DLEDC1DC2DC3DC4NAKSYNETBCANEM SUBESCFS GS RS US  '[i*3..i*3+2]||i.chr}"}
  a[-1]=a[-1][0..-2]
  x=16.times.map{|i|8.times.map{|j|a[i+j*16].rjust(j<2?10+j :9+j/6)}.join}.join"\n"
  x[-10]=''
  puts 'Dec Hex    '*2+'Dec Hex  '*4+' Dec Hex  '*2,"#{x}DEL"
end

solution(3) do
  puts 'Dec Hex    '*2+'Dec Hex  '*4+' Dec Hex  '*2,16.times.map{|i|8.times.map{|j|(127.times.map{|i|"#{i} #{'%.2X'%i} #{'NULSOHSTXETXEOTENQACKBELBS HT LF VT FF CR SO SI DLEDC1DC2DC3DC4NAKSYNETBCANEM SUBESCFS GS RS US  '[i*3..i*3+2]||i.chr}"}<<'  127 7F DEL')[i+j*16].rjust(j<2?10+j :9+j/6)}.join}.join("\n")
end

solution(4) do
  puts 'Dec Hex    '*2+'Dec Hex  '*4+' Dec Hex  '*2,16.times.map{|i|8.times.map{|j|(k=i+j*16;k==127?'  127 7F DEL':"#{k} #{'%.2X'%k} #{'NULSOHSTXETXEOTENQACKBELBS HT LF VT FF CR SO SI DLEDC1DC2DC3DC4NAKSYNETBCANEM SUBESCFS GS RS US  '[k*3..k*3+2]||k.chr}").rjust(j<2?10+j :9+j/6)}.join}.join("\n")
end

solution(5) do
  a='Dec Hex  ';puts"#{a}  "*2+a*4+" #{a}"*2,16.times.map{|i|8.times.map{|j|(k=i+j*16;k==127?'  127 7F DEL':"#{k} #{'%.2X'%k} #{'NULSOHSTXETXEOTENQACKBELBS HT LF VT FF CR SO SI DLEDC1DC2DC3DC4NAKSYNETBCANEM SUBESCFS GS RS US  '[k*3..k*3+2]||k.chr}").rjust(j<2?10+j :9+j/6)}.join}
end

run
