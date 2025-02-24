package com.robot.app.freshFightLevel
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserInfoManager;
   
   public class FightLevelModel
   {
      private static var info:Array;
      
      private static var currentBossId:Array;
      
      private static var curLevel:uint;
      
      private static var nextBossId:Array;
      
      private static var xmlClass:Class = FightLevelModel_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      private static const _maxLevel:uint = 30;
      
      private static var b1:Boolean = false;
      
      public function FightLevelModel()
      {
         super();
      }
      
      public static function setUp() : void
      {
         info = new Array();
         UserInfoManager.upDateMoreInfo(MainManager.actorInfo,upDatahandler);
      }
      
      private static function upDatahandler() : void
      {
         var obj:Object = null;
         var stage:uint = 0;
         trace("max\t" + MainManager.actorInfo.maxFreshStage);
         trace("cur\t" + MainManager.actorInfo.curFreshStage);
         for(var i1:int = 0; i1 < xml.level.length(); i1++)
         {
            obj = new Object();
            obj.id = xml.level[i1].@id;
            obj.itemId = xml.level[i1].@itemId;
            if(MainManager.actorInfo.maxFreshStage == 0)
            {
               obj.isOpen = false;
            }
            else
            {
               if(MainManager.actorInfo.maxFreshStage <= 10)
               {
                  stage = 1;
               }
               else if(MainManager.actorInfo.maxFreshStage == _maxLevel)
               {
                  stage = uint(_maxLevel / 10);
               }
               else if(MainManager.actorInfo.maxFreshStage % 10 == 0)
               {
                  stage = uint(MainManager.actorInfo.maxFreshStage / 10);
               }
               else
               {
                  stage = uint(uint(MainManager.actorInfo.maxFreshStage / 10) + 1);
               }
               if(uint(obj.id) <= stage)
               {
                  obj.isOpen = true;
               }
               else
               {
                  obj.isOpen = false;
               }
            }
            info.push(obj);
         }
         FightChoiceController.show();
      }
      
      public static function get list() : Array
      {
         return info;
      }
      
      public static function set setBossId(a:Array) : void
      {
         currentBossId = a;
      }
      
      public static function get getBossId() : Array
      {
         return currentBossId;
      }
      
      public static function set setCurLevel(lev:uint) : void
      {
         curLevel = lev;
      }
      
      public static function get getCurLevel() : uint
      {
         return curLevel;
      }
      
      public static function set setNextBossId(a:Array) : void
      {
         nextBossId = a;
      }
      
      public static function get getNextBossId() : Array
      {
         return nextBossId;
      }
      
      public static function get maxLevel() : uint
      {
         return _maxLevel;
      }
   }
}

