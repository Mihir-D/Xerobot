// extreme points calculating program

int iavg = 0, javg = 0;
int iprev1 = 0, iprev2, icurr = 0;
int iarr[];
int e = 0; // index of iarr[]
int start = 0;

void draw(){
  
  if(start == 0)
  {
  iprev1 = iavg;
  iprev2 = iavg;
  icurr = iavg;
  iarr[e++] = icurr;
  }
  
  icurr = iavg;
  
  if( abs(icurr - iprev1) > 10)
  {
  if(iprev2 - iprev1 < 0 && icurr - iprev1 >0 || iprev2 - iprev1 > 0 && icurr - iprev1 <0){
    iarr[e++] = icurr;
  }
  }
  
  iprev2 = iprev1;
  iprev1 = icurr;
  
}
