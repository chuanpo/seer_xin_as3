package com.adobe.images
{
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.*;
   
   public class JPGEncoder
   {
      private var fdtbl_UV:Array = new Array(64);
      
      private var std_ac_chrominance_values:Array = [0,1,2,3,17,4,5,33,49,6,18,65,81,7,97,113,19,34,50,129,8,20,66,145,161,177,193,9,35,51,82,240,21,98,114,209,10,22,36,52,225,37,241,23,24,25,26,38,39,40,41,42,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,130,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,226,227,228,229,230,231,232,233,234,242,243,244,245,246,247,248,249,250];
      
      private var std_dc_chrominance_values:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
      
      private var ZigZag:Array = [0,1,5,6,14,15,27,28,2,4,7,13,16,26,29,42,3,8,12,17,25,30,41,43,9,11,18,24,31,40,44,53,10,19,23,32,39,45,52,54,20,22,33,38,46,51,55,60,21,34,37,47,50,56,59,61,35,36,48,49,57,58,62,63];
      
      private var YDC_HT:Array;
      
      private var YAC_HT:Array;
      
      private var bytenew:int = 0;
      
      private var fdtbl_Y:Array = new Array(64);
      
      private var std_ac_chrominance_nrcodes:Array = [0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,119];
      
      private var DU:Array = new Array(64);
      
      private var std_ac_luminance_values:Array = [1,2,3,0,4,17,5,18,33,49,65,6,19,81,97,7,34,113,20,50,129,145,161,8,35,66,177,193,21,82,209,240,36,51,98,114,130,9,10,22,23,24,25,26,37,38,39,40,41,42,52,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,225,226,227,228,229,230,231,232,233,234,241,242,243,244,245,246,247,248,249,250];
      
      private var std_dc_chrominance_nrcodes:Array = [0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
      
      private var UVTable:Array = new Array(64);
      
      private var YDU:Array = new Array(64);
      
      private var UDU:Array = new Array(64);
      
      private var byteout:ByteArray;
      
      private var UVAC_HT:Array;
      
      private var UVDC_HT:Array;
      
      private var bytepos:int = 7;
      
      private var VDU:Array = new Array(64);
      
      private var std_ac_luminance_nrcodes:Array = [0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,125];
      
      private var std_dc_luminance_values:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
      
      private var YTable:Array = new Array(64);
      
      private var std_dc_luminance_nrcodes:Array = [0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0];
      
      private var bitcode:Array = new Array(65535);
      
      private var category:Array = new Array(65535);
      
      public function JPGEncoder(quality:Number = 50)
      {
         super();
         if(quality <= 0)
         {
            quality = 1;
         }
         if(quality > 100)
         {
            quality = 100;
         }
         var sf:int = 0;
         if(quality < 50)
         {
            sf = int(5000 / quality);
         }
         else
         {
            sf = int(200 - quality * 2);
         }
         initHuffmanTbl();
         initCategoryNumber();
         initQuantTables(sf);
      }
      
      private function initHuffmanTbl() : void
      {
         YDC_HT = computeHuffmanTbl(std_dc_luminance_nrcodes,std_dc_luminance_values);
         UVDC_HT = computeHuffmanTbl(std_dc_chrominance_nrcodes,std_dc_chrominance_values);
         YAC_HT = computeHuffmanTbl(std_ac_luminance_nrcodes,std_ac_luminance_values);
         UVAC_HT = computeHuffmanTbl(std_ac_chrominance_nrcodes,std_ac_chrominance_values);
      }
      
      private function RGB2YUV(img:BitmapData, xpos:int, ypos:int) : void
      {
         var x:int = 0;
         var P:uint = 0;
         var R:Number = NaN;
         var G:Number = NaN;
         var B:Number = NaN;
         var pos:int = 0;
         for(var y:int = 0; y < 8; y++)
         {
            for(x = 0; x < 8; x++)
            {
               P = img.getPixel32(xpos + x,ypos + y);
               R = Number(P >> 16 & 0xFF);
               G = Number(P >> 8 & 0xFF);
               B = Number(P & 0xFF);
               YDU[pos] = 0.299 * R + 0.587 * G + 0.114 * B - 128;
               UDU[pos] = -0.16874 * R + -0.33126 * G + 0.5 * B;
               VDU[pos] = 0.5 * R + -0.41869 * G + -0.08131 * B;
               pos++;
            }
         }
      }
      
      private function writeBits(bs:BitString) : void
      {
         var value:int = bs.val;
         var posval:int = bs.len - 1;
         while(posval >= 0)
         {
            if(Boolean(value & uint(1 << posval)))
            {
               bytenew |= uint(1 << bytepos);
            }
            posval--;
            --bytepos;
            if(bytepos < 0)
            {
               if(bytenew == 255)
               {
                  writeByte(255);
                  writeByte(0);
               }
               else
               {
                  writeByte(bytenew);
               }
               bytepos = 7;
               bytenew = 0;
            }
         }
      }
      
      private function writeWord(value:int) : void
      {
         writeByte(value >> 8 & 0xFF);
         writeByte(value & 0xFF);
      }
      
      private function writeByte(value:int) : void
      {
         byteout.writeByte(value);
      }
      
      private function writeDHT() : void
      {
         var i:int = 0;
         writeWord(65476);
         writeWord(418);
         writeByte(0);
         for(i = 0; i < 16; i++)
         {
            writeByte(std_dc_luminance_nrcodes[i + 1]);
         }
         for(i = 0; i <= 11; i++)
         {
            writeByte(std_dc_luminance_values[i]);
         }
         writeByte(16);
         for(i = 0; i < 16; i++)
         {
            writeByte(std_ac_luminance_nrcodes[i + 1]);
         }
         for(i = 0; i <= 161; i++)
         {
            writeByte(std_ac_luminance_values[i]);
         }
         writeByte(1);
         for(i = 0; i < 16; i++)
         {
            writeByte(std_dc_chrominance_nrcodes[i + 1]);
         }
         for(i = 0; i <= 11; i++)
         {
            writeByte(std_dc_chrominance_values[i]);
         }
         writeByte(17);
         for(i = 0; i < 16; i++)
         {
            writeByte(std_ac_chrominance_nrcodes[i + 1]);
         }
         for(i = 0; i <= 161; i++)
         {
            writeByte(std_ac_chrominance_values[i]);
         }
      }
      
      public function encode(image:BitmapData) : ByteArray
      {
         var xpos:int = 0;
         var fillbits:BitString = null;
         byteout = new ByteArray();
         bytenew = 0;
         bytepos = 7;
         writeWord(65496);
         writeAPP0();
         writeDQT();
         writeSOF0(image.width,image.height);
         writeDHT();
         writeSOS();
         var DCY:Number = 0;
         var DCU:Number = 0;
         var DCV:Number = 0;
         bytenew = 0;
         bytepos = 7;
         for(var ypos:int = 0; ypos < image.height; ypos += 8)
         {
            for(xpos = 0; xpos < image.width; xpos += 8)
            {
               RGB2YUV(image,xpos,ypos);
               DCY = processDU(YDU,fdtbl_Y,DCY,YDC_HT,YAC_HT);
               DCU = processDU(UDU,fdtbl_UV,DCU,UVDC_HT,UVAC_HT);
               DCV = processDU(VDU,fdtbl_UV,DCV,UVDC_HT,UVAC_HT);
            }
         }
         if(bytepos >= 0)
         {
            fillbits = new BitString();
            fillbits.len = bytepos + 1;
            fillbits.val = (1 << bytepos + 1) - 1;
            writeBits(fillbits);
         }
         writeWord(65497);
         return byteout;
      }
      
      private function initCategoryNumber() : void
      {
         var nr:int = 0;
         var nrlower:int = 1;
         var nrupper:int = 2;
         for(var cat:int = 1; cat <= 15; cat++)
         {
            for(nr = nrlower; nr < nrupper; nr++)
            {
               category[32767 + nr] = cat;
               bitcode[32767 + nr] = new BitString();
               bitcode[32767 + nr].len = cat;
               bitcode[32767 + nr].val = nr;
            }
            for(nr = -(nrupper - 1); nr <= -nrlower; nr++)
            {
               category[32767 + nr] = cat;
               bitcode[32767 + nr] = new BitString();
               bitcode[32767 + nr].len = cat;
               bitcode[32767 + nr].val = nrupper - 1 + nr;
            }
            nrlower <<= 1;
            nrupper <<= 1;
         }
      }
      
      private function writeDQT() : void
      {
         var i:int = 0;
         writeWord(65499);
         writeWord(132);
         writeByte(0);
         for(i = 0; i < 64; i++)
         {
            writeByte(YTable[i]);
         }
         writeByte(1);
         for(i = 0; i < 64; i++)
         {
            writeByte(UVTable[i]);
         }
      }
      
      private function writeAPP0() : void
      {
         writeWord(65504);
         writeWord(16);
         writeByte(74);
         writeByte(70);
         writeByte(73);
         writeByte(70);
         writeByte(0);
         writeByte(1);
         writeByte(1);
         writeByte(0);
         writeWord(1);
         writeWord(1);
         writeByte(0);
         writeByte(0);
      }
      
      private function writeSOS() : void
      {
         writeWord(65498);
         writeWord(12);
         writeByte(3);
         writeByte(1);
         writeByte(0);
         writeByte(2);
         writeByte(17);
         writeByte(3);
         writeByte(17);
         writeByte(0);
         writeByte(63);
         writeByte(0);
      }
      
      private function processDU(CDU:Array, fdtbl:Array, DC:Number, HTDC:Array, HTAC:Array) : Number
      {
         var i:int = 0;
         var startpos:int = 0;
         var nrzeroes:int = 0;
         var nrmarker:int = 0;
         var EOB:BitString = HTAC[0];
         var M16zeroes:BitString = HTAC[240];
         var DU_DCT:Array = fDCTQuant(CDU,fdtbl);
         for(i = 0; i < 64; i++)
         {
            DU[ZigZag[i]] = DU_DCT[i];
         }
         var Diff:int = DU[0] - DC;
         DC = Number(DU[0]);
         if(Diff == 0)
         {
            writeBits(HTDC[0]);
         }
         else
         {
            writeBits(HTDC[category[32767 + Diff]]);
            writeBits(bitcode[32767 + Diff]);
         }
         var end0pos:int = 63;
         while(end0pos > 0 && DU[end0pos] == 0)
         {
            end0pos--;
         }
         if(end0pos == 0)
         {
            writeBits(EOB);
            return DC;
         }
         i = 1;
         while(i <= end0pos)
         {
            startpos = i;
            while(DU[i] == 0 && i <= end0pos)
            {
               i++;
            }
            nrzeroes = i - startpos;
            if(nrzeroes >= 16)
            {
               for(nrmarker = 1; nrmarker <= nrzeroes / 16; nrmarker++)
               {
                  writeBits(M16zeroes);
               }
               nrzeroes = int(nrzeroes & 0x0F);
            }
            writeBits(HTAC[nrzeroes * 16 + category[32767 + DU[i]]]);
            writeBits(bitcode[32767 + DU[i]]);
            i++;
         }
         if(end0pos != 63)
         {
            writeBits(EOB);
         }
         return DC;
      }
      
      private function initQuantTables(sf:int) : void
      {
         var i:int = 0;
         var t:Number = NaN;
         var col:int = 0;
         var YQT:Array = [16,11,10,16,24,40,51,61,12,12,14,19,26,58,60,55,14,13,16,24,40,57,69,56,14,17,22,29,51,87,80,62,18,22,37,56,68,109,103,77,24,35,55,64,81,104,113,92,49,64,78,87,103,121,120,101,72,92,95,98,112,100,103,99];
         for(i = 0; i < 64; i++)
         {
            t = Math.floor((YQT[i] * sf + 50) / 100);
            if(t < 1)
            {
               t = 1;
            }
            else if(t > 255)
            {
               t = 255;
            }
            YTable[ZigZag[i]] = t;
         }
         var UVQT:Array = [17,18,24,47,99,99,99,99,18,21,26,66,99,99,99,99,24,26,56,99,99,99,99,99,47,66,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99];
         for(i = 0; i < 64; i++)
         {
            t = Math.floor((UVQT[i] * sf + 50) / 100);
            if(t < 1)
            {
               t = 1;
            }
            else if(t > 255)
            {
               t = 255;
            }
            UVTable[ZigZag[i]] = t;
         }
         var aasf:Array = [1,1.387039845,1.306562965,1.175875602,1,0.785694958,0.5411961,0.275899379];
         i = 0;
         for(var row:int = 0; row < 8; row++)
         {
            for(col = 0; col < 8; col++)
            {
               fdtbl_Y[i] = 1 / (YTable[ZigZag[i]] * aasf[row] * aasf[col] * 8);
               fdtbl_UV[i] = 1 / (UVTable[ZigZag[i]] * aasf[row] * aasf[col] * 8);
               i++;
            }
         }
      }
      
      private function writeSOF0(width:int, height:int) : void
      {
         writeWord(65472);
         writeWord(17);
         writeByte(8);
         writeWord(height);
         writeWord(width);
         writeByte(3);
         writeByte(1);
         writeByte(17);
         writeByte(0);
         writeByte(2);
         writeByte(17);
         writeByte(1);
         writeByte(3);
         writeByte(17);
         writeByte(1);
      }
      
      private function computeHuffmanTbl(nrcodes:Array, std_table:Array) : Array
      {
         var j:int = 0;
         var codevalue:int = 0;
         var pos_in_table:int = 0;
         var HT:Array = new Array();
         for(var k:int = 1; k <= 16; k++)
         {
            for(j = 1; j <= nrcodes[k]; j++)
            {
               HT[std_table[pos_in_table]] = new BitString();
               HT[std_table[pos_in_table]].val = codevalue;
               HT[std_table[pos_in_table]].len = k;
               pos_in_table++;
               codevalue++;
            }
            codevalue *= 2;
         }
         return HT;
      }
      
      private function fDCTQuant(data:Array, fdtbl:Array) : Array
      {
         var tmp0:Number = NaN;
         var tmp1:Number = NaN;
         var tmp2:Number = NaN;
         var tmp3:Number = NaN;
         var tmp4:Number = NaN;
         var tmp5:Number = NaN;
         var tmp6:Number = NaN;
         var tmp7:Number = NaN;
         var tmp10:Number = NaN;
         var tmp11:Number = NaN;
         var tmp12:Number = NaN;
         var tmp13:Number = NaN;
         var z1:Number = NaN;
         var z2:Number = NaN;
         var z3:Number = NaN;
         var z4:Number = NaN;
         var z5:Number = NaN;
         var z11:Number = NaN;
         var z13:Number = NaN;
         var i:int = 0;
         var dataOff:int = 0;
         for(i = 0; i < 8; i++)
         {
            tmp0 = data[dataOff + 0] + data[dataOff + 7];
            tmp7 = data[dataOff + 0] - data[dataOff + 7];
            tmp1 = data[dataOff + 1] + data[dataOff + 6];
            tmp6 = data[dataOff + 1] - data[dataOff + 6];
            tmp2 = data[dataOff + 2] + data[dataOff + 5];
            tmp5 = data[dataOff + 2] - data[dataOff + 5];
            tmp3 = data[dataOff + 3] + data[dataOff + 4];
            tmp4 = data[dataOff + 3] - data[dataOff + 4];
            tmp10 = tmp0 + tmp3;
            tmp13 = tmp0 - tmp3;
            tmp11 = tmp1 + tmp2;
            tmp12 = tmp1 - tmp2;
            data[dataOff + 0] = tmp10 + tmp11;
            data[dataOff + 4] = tmp10 - tmp11;
            z1 = (tmp12 + tmp13) * 0.707106781;
            data[dataOff + 2] = tmp13 + z1;
            data[dataOff + 6] = tmp13 - z1;
            tmp10 = tmp4 + tmp5;
            tmp11 = tmp5 + tmp6;
            tmp12 = tmp6 + tmp7;
            z5 = (tmp10 - tmp12) * 0.382683433;
            z2 = 0.5411961 * tmp10 + z5;
            z4 = 1.306562965 * tmp12 + z5;
            z3 = tmp11 * 0.707106781;
            z11 = tmp7 + z3;
            z13 = tmp7 - z3;
            data[dataOff + 5] = z13 + z2;
            data[dataOff + 3] = z13 - z2;
            data[dataOff + 1] = z11 + z4;
            data[dataOff + 7] = z11 - z4;
            dataOff += 8;
         }
         dataOff = 0;
         for(i = 0; i < 8; i++)
         {
            tmp0 = data[dataOff + 0] + data[dataOff + 56];
            tmp7 = data[dataOff + 0] - data[dataOff + 56];
            tmp1 = data[dataOff + 8] + data[dataOff + 48];
            tmp6 = data[dataOff + 8] - data[dataOff + 48];
            tmp2 = data[dataOff + 16] + data[dataOff + 40];
            tmp5 = data[dataOff + 16] - data[dataOff + 40];
            tmp3 = data[dataOff + 24] + data[dataOff + 32];
            tmp4 = data[dataOff + 24] - data[dataOff + 32];
            tmp10 = tmp0 + tmp3;
            tmp13 = tmp0 - tmp3;
            tmp11 = tmp1 + tmp2;
            tmp12 = tmp1 - tmp2;
            data[dataOff + 0] = tmp10 + tmp11;
            data[dataOff + 32] = tmp10 - tmp11;
            z1 = (tmp12 + tmp13) * 0.707106781;
            data[dataOff + 16] = tmp13 + z1;
            data[dataOff + 48] = tmp13 - z1;
            tmp10 = tmp4 + tmp5;
            tmp11 = tmp5 + tmp6;
            tmp12 = tmp6 + tmp7;
            z5 = (tmp10 - tmp12) * 0.382683433;
            z2 = 0.5411961 * tmp10 + z5;
            z4 = 1.306562965 * tmp12 + z5;
            z3 = tmp11 * 0.707106781;
            z11 = tmp7 + z3;
            z13 = tmp7 - z3;
            data[dataOff + 40] = z13 + z2;
            data[dataOff + 24] = z13 - z2;
            data[dataOff + 8] = z11 + z4;
            data[dataOff + 56] = z11 - z4;
            dataOff++;
         }
         for(i = 0; i < 64; i++)
         {
            data[i] = Math.round(data[i] * fdtbl[i]);
         }
         return data;
      }
   }
}

