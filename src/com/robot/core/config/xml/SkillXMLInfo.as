package com.robot.core.config.xml
{
   import flash.utils.Dictionary;
   
   public class SkillXMLInfo
   {
      private static var xmllist:XMLList;
      
      private static var sideEffectXMLList:XMLList;
      
      private static var xmlClass:Class = SkillXMLInfo_xmlClass;
      
      private static var SKILL_XML:XML = XML(new xmlClass());
      
      private static var categoryNames:Dictionary = new Dictionary();
      
      public static var dict:Dictionary = new Dictionary();
      
      parseInfo();
      
      public function SkillXMLInfo()
      {
         super();
      }
      
      private static function parseInfo() : void
      {
         xmllist = SKILL_XML.descendants("Move");
         sideEffectXMLList = SKILL_XML.descendants("SideEffect");
         dict["key_" + 1] = {
            "cn":"草",
            "en":"grass"
         };
         dict["key_" + 2] = {
            "cn":"水",
            "en":"water"
         };
         dict["key_" + 3] = {
            "cn":"火",
            "en":"fire"
         };
         dict["key_" + 4] = {
            "cn":"飞行",
            "en":"fly"
         };
         dict["key_" + 5] = {
            "cn":"电",
            "en":"bolt"
         };
         dict["key_" + 6] = {
            "cn":"机械",
            "en":"steel"
         };
         dict["key_" + 7] = {
            "cn":"地面",
            "en":"ground"
         };
         dict["key_" + 8] = {
            "cn":"普通",
            "en":"normal"
         };
         dict["key_" + 9] = {
            "cn":"冰",
            "en":"ice"
         };
         dict["key_" + 10] = {
            "cn":"超能",
            "en":"super"
         };
         dict["key_" + 11] = {
            "cn":"战斗",
            "en":"fight"
         };
         dict["key_" + 12] = {
            "cn":"光",
            "en":"light"
         };
         dict["key_" + 13] = {
            "cn":"暗影",
            "en":"dark"
         };
         dict["key_" + 14] = {
            "cn":"神秘",
            "en":"secrect"
         };
         dict["key_" + 15] = {
            "cn":"龙",
            "en":"dragon"
         };
         dict["key_" + 16] = {
            "cn":"圣灵",
            "en":"god"
         };
         categoryNames["key_" + 1] = "物理攻击";
         categoryNames["key_" + 2] = "特殊攻击";
         categoryNames["key_" + 4] = "属性攻击";
      }
      
      public static function getName(id:uint) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@Name;
      }
      
      public static function getDamage(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@Power;
      }
      
      public static function getPP(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@MaxPP;
      }
      
      public static function hitP(id:uint) : Number
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@Accuracy;
      }
      
      public static function getSideEffects(id:uint) : Array
      {
         var xml:XML = null;
         var _add:Array = null;
         xml = xmllist.(@ID == id)[0];
         _add = String(xml.@SideEffect).split(" ");
         return _add;
      }
      
      public static function getSideEffectArgs(id:uint) : Array
      {
         var xml:XML = null;
         var _add:Array = null;
         xml = xmllist.(@ID == id)[0];
         _add = String(xml.@SideEffectArg).split(" ");
         return _add;
      }
      
      public static function getCategory(id:uint) : int
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(!xml)
         {
            return 0;
         }
         return xml.@Category;
      }
      
      public static function getCategoryName(id:uint) : String
      {
         return categoryNames["key_" + getCategory(id)];
      }
      
      public static function getTypeCN(id:uint) : String
      {
         var xml:XML = null;
         var type:String = null;
         if(getCategory(id) == 4)
         {
            return "属性";
         }
         xml = xmllist.(@ID == id)[0];
         type = xml.@Type;
         return dict["key_" + type]["cn"];
      }
      
      public static function getTypeCNBytTypeID(typeid:uint) : String
      {
         return dict["key_" + typeid]["cn"];
      }
      
      public static function getTypeEN(id:uint) : String
      {
         var xml:XML = null;
         var type:String = null;
         if(getCategory(id) == 4)
         {
            return "prop";
         }
         xml = xmllist.(@ID == id)[0];
         type = xml.@Type;
         return dict["key_" + type]["en"];
      }
      
      public static function getInfo(id:uint) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@info;
      }
      
      public static function getDes(id:uint) : String
      {
         var xml:XML = null;
         xml = sideEffectXMLList.(@ID == id)[0];
         return xml.@des;
      }
      
      public static function petTypeName(id:uint) : String
      {
         var cc:String = dict["key_" + id]["cn"];
         return dict["key_" + id]["cn"];
      }
   }
}

