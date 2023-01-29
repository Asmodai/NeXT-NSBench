/* slice.c generated from slice.pswraps
   by unix pswrap V1.009  Wed Apr 19 17:50:24 PDT 1989
 */

#include <dpsclient/dpsfriends.h>
#include <string.h>

#line 1 "slice.pswraps"
#line 10 "slice.c"
void drawSlice(grayshade, radius, startangle, endangle, labelps, thelabel)
float grayshade; float radius; float startangle; float endangle; float labelps; char *thelabel; 
{
  typedef struct {
    unsigned char tokenType;
    unsigned char sizeFlag;
    unsigned short topLevelCount;
    unsigned long nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjReal obj8;
    DPSBinObjReal obj9;
    DPSBinObjReal obj10;
    DPSBinObjGeneric obj11;
    DPSBinObjGeneric obj12;
    DPSBinObjReal obj13;
    DPSBinObjGeneric obj14;
    DPSBinObjGeneric obj15;
    DPSBinObjGeneric obj16;
    DPSBinObjGeneric obj17;
    DPSBinObjReal obj18;
    DPSBinObjGeneric obj19;
    DPSBinObjGeneric obj20;
    DPSBinObjGeneric obj21;
    DPSBinObjGeneric obj22;
    DPSBinObjGeneric obj23;
    DPSBinObjReal obj24;
    DPSBinObjReal obj25;
    DPSBinObjGeneric obj26;
    DPSBinObjGeneric obj27;
    DPSBinObjGeneric obj28;
    DPSBinObjGeneric obj29;
    DPSBinObjReal obj30;
    DPSBinObjGeneric obj31;
    DPSBinObjGeneric obj32;
    DPSBinObjGeneric obj33;
    DPSBinObjGeneric obj34;
    DPSBinObjGeneric obj35;
    DPSBinObjGeneric obj36;
    DPSBinObjReal obj37;
    DPSBinObjReal obj38;
    DPSBinObjGeneric obj39;
    DPSBinObjGeneric obj40;
    DPSBinObjGeneric obj41;
    DPSBinObjGeneric obj42;
    DPSBinObjReal obj43;
    DPSBinObjGeneric obj44;
    DPSBinObjGeneric obj45;
    DPSBinObjGeneric obj46;
    DPSBinObjGeneric obj47;
    DPSBinObjGeneric obj48;
    DPSBinObjGeneric obj49;
    DPSBinObjGeneric obj50;
    DPSBinObjGeneric obj51;
    DPSBinObjGeneric obj52;
    DPSBinObjGeneric obj53;
    DPSBinObjGeneric obj54;
    DPSBinObjGeneric obj55;
    DPSBinObjGeneric obj56;
    DPSBinObjGeneric obj57;
    DPSBinObjGeneric obj58;
    DPSBinObjGeneric obj59;
    DPSBinObjGeneric obj60;
    DPSBinObjGeneric obj61;
    DPSBinObjGeneric obj62;
    DPSBinObjGeneric obj63;
    DPSBinObjGeneric obj64;
    DPSBinObjGeneric obj65;
    DPSBinObjGeneric obj66;
    DPSBinObjGeneric obj67;
    DPSBinObjGeneric obj68;
    DPSBinObjGeneric obj69;
    DPSBinObjGeneric obj70;
    DPSBinObjGeneric obj71;
    DPSBinObjGeneric obj72;
    DPSBinObjReal obj73;
    DPSBinObjGeneric obj74;
    DPSBinObjGeneric obj75;
    DPSBinObjGeneric obj76;
    DPSBinObjGeneric obj77;
    DPSBinObjGeneric obj78;
    DPSBinObjGeneric obj79;
    DPSBinObjGeneric obj80;
    DPSBinObjGeneric obj81;
    } _dpsQ;
  static _dpsQ _dpsF = {
    DPS_DEF_TOKENTYPE, 0, 72, 664,
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 155},	/* setlinewidth */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 111},	/* newpath */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 107},	/* moveto */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: radius */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: startangle */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: endangle */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 5},	/* arc */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 22},	/* closepath */
    {DPS_LITERAL|DPS_REAL, 0, 0, 1.415},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 346},	/* setmiterlimit */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 155},	/* setlinewidth */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: grayshade */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 150},	/* setgray */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 66},	/* fill */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 167},	/* stroke */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: startangle */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: endangle */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 1},	/* add */
    {DPS_LITERAL|DPS_INT, 0, 0, 2},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 54},	/* div */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 136},	/* rotate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: radius */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 173},	/* translate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 111},	/* newpath */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 107},	/* moveto */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: labelps */
    {DPS_LITERAL|DPS_REAL, 0, 0, .8},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 108},	/* mul */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 99},	/* lineto */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 167},	/* stroke */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: labelps */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 173},	/* translate */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 172},	/* transform */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 95},	/* itransform */
    {DPS_LITERAL|DPS_NAME, 0, DPSSYSNAME, 426},	/* y */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, DPSSYSNAME, 425},	/* x */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 425},	/* x */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 426},	/* y */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 107},	/* moveto */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 425},	/* x */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 102},	/* lt */
    {DPS_EXEC|DPS_ARRAY, 0, 6, 608},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 426},	/* y */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 102},	/* lt */
    {DPS_EXEC|DPS_ARRAY, 0, 4, 576},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_LITERAL|DPS_STRING, 0, 0, 656},	/* param thelabel */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 160},	/* show */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: labelps */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 110},	/* neg */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 134},	/* rmoveto */
    {DPS_LITERAL|DPS_STRING, 0, 0, 656},	/* param thelabel */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 166},	/* stringwidth */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 110},	/* neg */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 134},	/* rmoveto */
    }; /* _dpsQ */
  register DPSContext _dpsCurCtxt = DPSPrivCurrentContext();
  char pad[3];
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  register int _dps_offset = 656;

  _dpsP[18].val.realVal = grayshade;
  _dpsP[8].val.realVal =
  _dpsP[30].val.realVal = radius;
  _dpsP[9].val.realVal =
  _dpsP[24].val.realVal = startangle;
  _dpsP[10].val.realVal =
  _dpsP[25].val.realVal = endangle;
  _dpsP[37].val.realVal =
  _dpsP[43].val.realVal =
  _dpsP[73].val.realVal = labelps;
  _dpsP[76].length =
  _dpsP[70].length = strlen(thelabel);
  _dpsP[76].val.stringVal = _dps_offset;
  _dps_offset += (_dpsP[76].length + 3) & ~3;
  _dpsP[70].val.stringVal = _dps_offset;
  _dps_offset += (_dpsP[70].length + 3) & ~3;

  _dpsF.nBytes = _dps_offset+8;
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,664);
  DPSWriteStringChars(_dpsCurCtxt, (char *)thelabel, _dpsP[76].length);
  DPSWriteStringChars(_dpsCurCtxt, (char *)pad, ~(_dpsP[76].length + 3) & 3);
  DPSWriteStringChars(_dpsCurCtxt, (char *)thelabel, _dpsP[70].length);
  DPSWriteStringChars(_dpsCurCtxt, (char *)pad, ~(_dpsP[70].length + 3) & 3);
  if (0) *pad = 0;    /* quiets compiler warnings */
}
#line 33 "slice.pswraps"


