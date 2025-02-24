package com.robot.core.ui.mapTip
{
   import com.robot.core.config.xml.MapIntroXMLInfo;
   
   public class MapItemTipInfo
   {
      public var type:uint;
      
      public var title:String;
      
      public var content:Array;
      
      public function MapItemTipInfo(mapID:uint, tp:uint)
      {
         super();
         this.type = tp;
         switch(this.type)
         {
            case 0:
               this.title = MapIntroXMLInfo.getDes(mapID);
               this.content = [MapIntroXMLInfo.getDifficulty(mapID),MapIntroXMLInfo.getLevel(mapID)];
               break;
            case 1:
               this.title = "任务";
               this.content = MapIntroXMLInfo.getTasks(mapID);
               break;
            case 2:
               this.title = "精灵";
               this.content = MapIntroXMLInfo.getSprites(mapID);
               break;
            case 3:
               this.title = "矿产";
               this.content = MapIntroXMLInfo.getMinerals(mapID);
               break;
            case 4:
               this.title = "游戏";
               this.content = MapIntroXMLInfo.getGames(mapID);
               break;
            case 5:
               this.title = "NoNo";
               this.content = MapIntroXMLInfo.getNonos(mapID);
               break;
            case 6:
               this.title = "新品上架";
               this.content = MapIntroXMLInfo.getNewgoods(mapID);
               break;
            default:
               this.title = "";
               this.content = [];
         }
      }
   }
}

