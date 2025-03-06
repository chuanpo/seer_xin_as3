package com.robot.core.npc
{
   public class NPC
   {
      public static const SHIPER:uint = 1;
      
      public static const CICI:uint = 2;
      
      public static const DOCTOR:uint = 3;
      
      public static const IRIS:uint = 4;
      
      public static const LYMAN:uint = 5;
      
      public static const SHAWN:uint = 6;
      
      public static const ELDER:uint = 7;
      
      public static const SHUKE:uint = 8;
      
      public static const ROCKY:uint = 9;
      
      public static const JILIGUALA:uint = 10;
      
      public static const SEER:uint = 20;
      
      public static const JUSTIN:uint = 11;
      
      public static const WULIGULA:uint = 12;
      
      public static const ALLISON:uint = 13;
      
      public static const ZOG:uint = 14;
      
      public static const GAIYA:uint = 261;
      
      public static const PIPI:uint = 50;
      
      public static const MAOMAO:uint = 51;
      
      public static const TIYASI:uint = 52;
      
      public static const NEWFISH:uint = 53;
      
      public static const EVA:uint = 54;
      
      public static const BIGMAOMAO:uint = 55;
      
      public static const PENNY:uint = 56;
      
      public static const PENNYHIGH:uint = 57;
      
      public static const GELIN:uint = 62;
      
      public static const BULU:uint = 108;
      
      public static const BULUGELIN:uint = 500;
      
      public static const LAMU:uint = 501;
      
      public static const PUTI:uint = 502;
      
      public static const DAWEI:uint = 503;
      
      public static const QISHI:uint = 504;
      
      public static const NIBU:uint = 505;
      
      public static const SUPERNONO:uint = 111;
      
      public static const NONO:uint = 110;
      
      public function NPC()
      {
         super();
      }
      
      public static function getSceneNpcPathById(id:uint) : String
      {
         return "resource/newNpc/multi/" + id + ".swf";
      }
      
      public static function getDialogNpcPathById(id:uint) : String
      {
         return "resource/newNpc/" + (id > 2891 ? "dialog/" : "oneSide/")+ id + ".swf";
      }
   }
}

