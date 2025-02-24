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
            info.id = uint(xml.@id);
            info.description = xml.@description;
            info.enterID = uint(xml.@enterID);
            info.level = uint(xml.@lel);
            info.onLine = Boolean(xml.@online);
            info.seatID = uint(xml.@seatID);
            info.status = uint(TasksManager.taskList[info.id - 1]);
            info.title = xml.@title;
            info.fightCondition = xml.@fightCondition;
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

