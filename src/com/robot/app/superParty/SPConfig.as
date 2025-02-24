package com.robot.app.superParty
{
   public class SPConfig
   {
      private static var _infoA:Array;
      
      private static var xmlClass:Class = SPConfig_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function SPConfig()
      {
         super();
      }
      
      public static function makeInfo() : void
      {
         var xml:XML = null;
         var info:SuperPartyInfo = null;
         _infoA = new Array();
         var xmlList:XMLList = xml.elements("SP");
         for each(xml in xmlList)
         {
            info = new SuperPartyInfo();
            if(xml.@games == "")
            {
               info.games = new Array();
            }
            else
            {
               info.games = String(xml.@games).split("|");
            }
            info.mapID = uint(xml.@mapID);
            if(xml.@oreIDs == "")
            {
               info.oreIDs = new Array();
            }
            else
            {
               info.oreIDs = String(xml.@oreIDs).split("|");
            }
            if(xml.@petIDs != "")
            {
               info.petIDs = String(xml.@petIDs).split("|");
            }
            else
            {
               info.petIDs = new Array();
            }
            _infoA.push(info);
         }
      }
      
      public static function get infos() : Array
      {
         if(!_infoA)
         {
            makeInfo();
         }
         return _infoA;
      }
      
      public static function get title() : String
      {
         var xml:XML = null;
         var xmlList:XMLList = xml.elements("title");
         var str:String = "";
         for each(xml in xmlList)
         {
            str += xml.@msg;
         }
         return str;
      }
   }
}

