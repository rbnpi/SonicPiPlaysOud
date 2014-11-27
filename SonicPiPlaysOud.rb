#music for oud on Sonic Pi by Robin Newman Nov 2014
use_debug false
 #adjust sample path for the absolute path to the samples for your system and copy OUD folder there
#use_sample_pack "/Users/rbn/Desktop/samples/OUD" #This line works on my Mac
use_sample_pack "/home/pi/samples/OUD" #This line used on my Pi
rt=2**(1.0/12) #12th root of 2 multiplier for adjacent semitones
irt=1.0/rt #inverse multiplier for one semitone down

sc=[[:c4,:OUD_c4,1],[:d4,:OUD_d4,1],[:eb4,:OUD_d4,rt],[:e4,:OUD_d4,rt],[:f4,:OUD_fs4,irt],[:fs4,:OUD_fs4,1],[:g4,:OUD_g4,1],[:a4,:OUD_a4,1],[:bb4,:OUD_a4,rt]]
sc.concat [[:c5,:OUD_c4,2],[:d5,:OUD_d4,2],[:eb5,:OUD_d4,rt*2]] #array containg lists of note,sample and rate

define :pl do |n,d=0.2|#play a note using the associated sample
  sample sc.assoc(n)[1],rate: sc.assoc(n)[2],attack: d*0.05,sustain: d*0.85,release: d*0.1
end

hdsq=dsq=sq=sqd=q=qd=qdd=c=cd=cdd=m=mm=md=mdd=b=bd=s=0 #define variables to set their scope
n1=d1=n2=d2=n3=d3=n4=d4=nintro=dintro=[] #they are then filled by functions nd and tune

use_synth :saw
set_sched_ahead_time! 2

define :nd do |s| #function to set note durations in terms of s
hdsq = 0.5 * s
dsq = 1 * s
sq = 2 * s
sqd = 3 * s
q = 4 * s
qd = 6 * s
qdd = 7 * s
c = 8 * s
cd = 12 * s
cdd = 14 * s
m = 16 * s
md = 24 * s
mdd = 28 * s
b = 32 * s
bd = 48 * s
end

define :plarray do |nt,dur| #plays note and duration lists using samples
  nt.zip(dur).each do |n,d|
    if n!= :r then
      pl(n,d)
    end
    sleep d
  end
end
define :playsynth do |nt,dur| #plays note and duration lists using synth
  nt.zip(dur).each do |n,d|
    play n,sustain: d*0.9,release: d*0.1,amp: 0.4
    sleep d
  end
end

define :tune do #define the notes and durations for the intro and 4 sections of the piece
nintro=[:d4]*18
dintro=[q,sq,sq,q,sq,sq,q,q,c,q,sq,sq,q,sq,sq,q,q,c]
n1=[:d4,:a4,:g4,:a4,:f4,:g4,:a4,:a4,:d4,:a4,:g4,:a4,:f4,:g4,:a4,:g4,:d4,:a4,:g4,:a4,:f4,:g4,:a4,:a4,:f4,:f4,:f4,:g4,:f4,:eb4,:d4]
d1=[q,q,q,q,q,q,q,q,q,q,q,q,q,sq,sq,c,q,q,q,q,q,q,q,q,q,q,q,q,q,q,c]
n2=[:r,:g4,:f4,:eb4,:d4,:eb4,:f4,:g4,:a4,:g4,:r,:c5,:a4,:bb4,:a4,:g4,:f4,:eb4,:g4,:f4,:eb4,:eb4]
n2.concat [:r,:g4,:f4,:eb4,:d4,:eb4,:f4,:f4,:g4,:a4,:g4,:r,:a4,:bb4,:c5,:d5,:g4,:f4,:g4,:eb4,:f4,:d4,:eb4,:d4]
d2=[q,q,q,q,cd,q,c,c,c,c,q,q,q,dsq,sqd,c,c,q,q,q,q,m]
d2.concat [q,q,q,q,c,c,c,q,q,c,c,q,q,q,q,c,c,q,q,q,q,c,q,q]
n3=[:r,:a4,:a4,:g4,:g4,:f4,:f4,:eb4,:f4,:eb4,:d4,:r,:a4,:a4,:g4,:g4,:g4,:g4,:c5,:c5,:d5,:c5,:bb4,:a4]
d3=[q,q,q,q,cd,q,c,q,q,c,c,q,q,q,q,c,q,q,c,q,q,q,q,c]
n4=[:r,:bb4,:bb4,:bb4,:bb4,:f4,:f4,:g4,:a4,:f4,:eb4,:d4,:r,:d4,:eb4,:f4,:g4,:g4,:r,:g4,:a4,:g4,:bb4]
n4.concat [:r,:bb4,:bb4,:c5,:bb4,:f4,:bb4,:bb4,:d5,:eb5,:c5,:bb4,:c5,:d5,:bb4,:a4,:bb4,:c5,:a4,:g4,:a4,:bb4,:g4]
n4.concat [:r,:a4,:bb4,:c5,:d5,:g4,:f4,:g4,:eb4,:f4,:d4,:eb4,:d4]
d4=[q,q,q,q,c,q,q,c,c,qd,sq,c,q,q,q,q,c,c,q,q,c,c,c]
d4.concat [q,q,q,q,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q]
d4.concat [q,q,q,q,c,c,q,q,q,q,c,q,q]
end

define :plsample do |s| #used for playing the voice samples
sample s
sleep sample_duration s
end
#voice description and program output starts here==========================
plsample(:voice1)
plsample(:voice2)

plarray([:c4,:d4,:fs4,:g4,:a4],[0.4]*5) #play the intial 5 samples used
plsample(:voice3)
play_pattern_timed [:c4,:d4,:fs4,:g4,:a4],[0.4],sustain: 0.2 ,release: 0.2,amp:0.4
sleep 2
plsample(:voice4)

plsample(:voice5)
plarray([:d4,:eb4,:f4,:g4,:a4,:bb4,:c5,:d5,:eb5],[0.4]*9) #play the nine notes generated from the samples
plsample(:voice6)
plsample(:voice7)
plsample(:voice8)
sleep 2
nd(1.0/24) #set a fast tempo and define note durations
tune #define the notes and durations

playsynth(nintro,dintro) #play tune with synth
playsynth(n1,d1)
playsynth(n1,d1)
playsynth(n2,d2)
playsynth(n2,d2)
playsynth(n3,d3)
playsynth(n3,d3)
playsynth(n4,d4)
playsynth(n1,d1)
plsample(:voice9)
sleep 2
nd(1.0/18) #define a slower tempo
tune #redefine notes and durations
plarray(nintro,dintro) #play using samples
plarray(n1,d1)
plarray(n1,d1)
plarray(n2,d2)
plarray(n2,d2)
plarray(n3,d3)
plarray(n3,d3)
plarray(n4,d4)
plarray(n1,d1)
sleep 1
plsample(:voice10)