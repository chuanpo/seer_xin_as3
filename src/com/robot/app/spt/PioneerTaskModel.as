package com.robot.app.spt
{
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.Alarm;

   public class PioneerTaskModel
   {
      private static var _infoA:Array;
      
      private static var xmlClass:Class = PioneerTaskModel_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function PioneerTaskModel()
      {
         super();
      }
      
      public static function setup() : void
      {
         _infoA = new Array();
         makeListInfo();
      }
      
      public static function makeListInfo() : void
      {
         var xmlItem:XML = null;
         var info:SptInfo = null;
         var xmlList:XMLList = xml.elements("spt");
         _infoA = new Array();
         for each(xmlItem in xmlList)
         {
            info = new SptInfo();
            info.id = uint(xmlItem.@id);
            info.description = xmlItem.@description;
            info.enterID = uint(xmlItem.@enterID);
            info.level = uint(xmlItem.@lel);
            info.onLine = Boolean(xmlItem.@online);
            info.seatID = uint(xmlItem.@seatID);
            info.status = uint(TasksManager.taskList[info.id - 1]);
            info.title = xmlItem.@title;
            info.fightCondition = xmlItem.@fightCondition;
            _infoA.push(info);
         }
      }
      
      public static function get infoA() : Array
      {
         if(!_infoA)
         {
            makeListInfo();
         }
         return _infoA;
      }
   }
}

