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
         var xmlItem:XML = null;
         var info:SuperPartyInfo = null;
         _infoA = new Array();
         var xmlList:XMLList = xml.elements("SP");
         for each(xmlItem in xmlList)
         {
            info = new SuperPartyInfo();
            if(xmlItem.@games == "")
            {
               info.games = new Array();
            }
            else
            {
               info.games = String(xmlItem.@games).split("|");
            }
            info.mapID = uint(xmlItem.@mapID);
            if(xmlItem.@oreIDs == "")
            {
               info.oreIDs = new Array();
            }
            else
            {
               info.oreIDs = String(xmlItem.@oreIDs).split("|");
            }
            if(xmlItem.@petIDs != "")
            {
               info.petIDs = String(xmlItem.@petIDs).split("|");
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
         var xmlItem:XML = null;
         var xmlList:XMLList = xml.elements("title");
         var str:String = "";
         for each(xmlItem in xmlList)
         {
            str += xmlItem.@msg;
         }
         return str;
      }
   }
}

