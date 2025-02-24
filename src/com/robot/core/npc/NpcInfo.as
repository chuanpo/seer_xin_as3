package com.robot.core.npc
{
   import com.robot.core.config.xml.NpcXMLInfo;
   import flash.geom.Point;
   
   public class NpcInfo
   {
      public var bubbingList:Array;
      
      public var dialogList:Array;
      
      public var point:Point;
      
      public var clothIds:Array;
      
      public var npcId:uint;
      
      public var npcMap:uint;
      
      public var npcName:String;
      
      public var color:uint;
      
      public var npcPath:String;
      
      public var type:String;
      
      public var startIDs:Array;
      
      public var endIDs:Array;
      
      public var proIDs:Array;
      
      public var offSetPoint:Point;
      
      public var questionA:Array;
      
      public function NpcInfo(xml:XMLList = null)
      {
         var p:Array = null;
         var i:XML = null;
         var a:Array = null;
         this.bubbingList = [];
         this.dialogList = [];
         this.clothIds = [];
         super();
         if(Boolean(xml))
         {
            this.npcId = uint(xml.@id);
            this.npcMap = uint(xml.@mapID);
            this.npcName = xml.@name;
            this.color = uint(xml.@color);
            this.type = xml.@type;
            if(Boolean(xml.@offSetPoint))
            {
               a = String(xml.@offSetPoint).split("|");
               this.offSetPoint = new Point(uint(a[0]),uint(a[1]));
            }
            else
            {
               this.offSetPoint = new Point();
            }
            if(Boolean(xml.question))
            {
               this.questionA = String(xml.question).split("$");
            }
            else
            {
               this.questionA = [];
            }
            this.startIDs = NpcXMLInfo.getStartIDs(this.npcId);
            this.endIDs = NpcXMLInfo.getEndIDs(this.npcId);
            this.proIDs = NpcXMLInfo.getNpcProIDs(this.npcId);
            this.npcPath = NPC.getSceneNpcPathById(this.npcId);
            p = String(xml.@point).split("|");
            this.point = new Point(uint(p[0]),uint(p[1]));
            if(Boolean(xml.hasOwnProperty("@cloths")))
            {
               this.clothIds = String(xml.@cloths).split("|");
            }
            else
            {
               this.clothIds = [];
            }
            for each(i in xml.dialog.list)
            {
               this.bubbingList.push(i.@str);
            }
            if(Boolean(xml.des))
            {
               this.dialogList = String(xml.des).split("$");
            }
            else
            {
               this.dialogList = [];
            }
         }
      }
   }
}

