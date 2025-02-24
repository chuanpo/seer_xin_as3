package com.robot.core.ui.mapTip
{
   import com.robot.core.config.xml.MapIntroXMLInfo;
   
   public class MapTipInfo
   {
      public var id:uint;
      
      public var contentList:Array = [];
      
      private var taskList:Array;
      
      private var newTaskList:Array;
      
      private var spriteList:Array;
      
      private var mineralsList:Array;
      
      private var gameList:Array;
      
      private var nonoList:Array;
      
      private var newgoodsList:Array;
      
      public function MapTipInfo(id:uint)
      {
         super();
         this.id = id;
         this.contentList.push(0);
         this.taskList = MapIntroXMLInfo.getTasks(id);
         if(this.taskList.length > 0)
         {
            this.contentList.push(1);
         }
         this.spriteList = MapIntroXMLInfo.getSprites(id);
         if(this.spriteList.length > 0)
         {
            this.contentList.push(2);
         }
         this.mineralsList = MapIntroXMLInfo.getMinerals(id);
         if(this.mineralsList.length > 0)
         {
            this.contentList.push(3);
         }
         this.gameList = MapIntroXMLInfo.getGames(id);
         if(this.gameList.length > 0)
         {
            this.contentList.push(4);
         }
         this.nonoList = MapIntroXMLInfo.getNonos(id);
         if(this.nonoList.length > 0)
         {
            this.contentList.push(5);
         }
         this.newgoodsList = MapIntroXMLInfo.getNewgoods(id);
         if(this.newgoodsList.length > 0)
         {
            this.contentList.push(6);
         }
      }
   }
}

