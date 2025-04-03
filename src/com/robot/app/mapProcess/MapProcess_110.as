package com.robot.app.mapProcess
{
   import com.robot.app.darkPortal.DarkPortalModel;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetBookXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   import com.robot.core.config.xml.PetXMLInfo;
   
   public class MapProcess_110 extends BaseMapProcess
   {
      private var _timer:uint;
      
      private const _petId:uint = 169;
      
      private var _point:Point = new Point(479.9,335);
      
      private var _perMc:MovieClip;
      
      private var _collId:uint = 400053;
      
      private var _doorIndex:uint;
      
      private var _lenght:uint = 5;
      
      private var _tipsA:Array = ["暗黑第一门","暗黑第二门","暗黑第三门","暗黑第四门","暗黑第五门"];
      
      private var _so:SharedObject;
      
      private var _bookApp:AppModel;
      
      private var _targetMC:MovieClip;
      
      public function MapProcess_110()
      {
         super();
      }
      
      override protected function init() : void
      {
         ToolTipManager.add(conLevel["monsterMc"],"试炼之门");
         conLevel["monsterMc"].gotoAndStop(1);
         conLevel["monsterMc"].visible = true;
         conLevel["monsterMc"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         conLevel["monsterMc"].addEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         conLevel["monsterMc"].addEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         for(var i1:int = 0; i1 < this._lenght; i1++)
         {
            conLevel["darkMc_" + i1].addEventListener(MouseEvent.CLICK,this.onDoorMcClickHandler);
            conLevel["darkMc_" + i1].buttonMode = true;
            ToolTipManager.add(conLevel["darkMc_" + i1],this._tipsA[i1]);
         }
         this._so = SOManager.getUserSO(SOManager.Is_Readed_DarkBook);
         if(this._so.data.hasOwnProperty("isShow"))
         {
            if(this._so.data["isShow"] == true)
            {
               conLevel["darkBookMc"]["mc"].gotoAndStop(1);
               conLevel["darkBookMc"]["mc"].visible = false;
            }
         }
         else
         {
            this._so.data["isShow"] = false;
            SOManager.flush(this._so);
         }
         ToolTipManager.add(conLevel["darkBookMc"],"暗黑武斗手册");
         conLevel["darkBookMc"].buttomMode = true;
         conLevel["darkBookMc"].addEventListener(MouseEvent.MOUSE_OVER,this.onBookOverHandler);
         conLevel["darkBookMc"].addEventListener(MouseEvent.MOUSE_OUT,this.onBookOutHandler);
         conLevel["darkBookMc"].addEventListener(MouseEvent.CLICK,this.onBookHandler);
      }
      
      private function onBookHandler(e:MouseEvent) : void
      {
         this._so.data["isShow"] = true;
         SOManager.flush(this._so);
         conLevel["darkBookMc"]["mc"].visible = false;
         conLevel["darkBookMc"]["mc"].gotoAndStop(1);
         if(this._bookApp == null)
         {
            this._bookApp = new AppModel(ClientConfig.getBookModule("DarkProtalBookPanel"),"正在打开");
            this._bookApp.setup();
         }
         this._bookApp.show();
      }
      
      private function onBookOverHandler(e:MouseEvent) : void
      {
         conLevel["darkBookMc"].gotoAndStop(2);
      }
      
      private function onBookOutHandler(e:MouseEvent) : void
      {
         conLevel["darkBookMc"].gotoAndStop(1);
      }
      
      private function onOverHandler(e:MouseEvent) : void
      {
         conLevel["monsterMc"].gotoAndStop(2);
      }
      
      private function onOutHandler(e:MouseEvent) : void
      {
         conLevel["monsterMc"].gotoAndStop(1);
      }
      
      private function showDoor() : void
      {
         if(Boolean(this._targetMC))
         {
            this._targetMC.visible = true;
            this._targetMC = null;
         }
      }
      
      private function onDoorMcClickHandler(e:MouseEvent) : void
      {
         this.showDoor();
         this._targetMC = e.currentTarget as MovieClip;
         this._targetMC.visible = false;
         var nameStr:String = e.currentTarget.name;
         this._doorIndex = uint(nameStr.slice(7,nameStr.length));
         if(MainManager.actorInfo.superNono == true)
         {
            if(NonoManager.info.superLevel < this._doorIndex + 1)
            {
               NpcTipDialog.show("你的超能NoNo必须成长为超能" + TextFormatUtil.getRedTxt((this._doorIndex + 1).toString()) + "级才能帮你开启暗黑第" + (this._doorIndex + 1) + "门。",null,NpcTipDialog.NONO);
               return;
            }
            DarkPortalModel.curDoor = this._doorIndex;
            DarkPortalModel.showDoor(this._doorIndex,this.showDoor);
         }
         else
         {
            if(this._doorIndex > 0)
            {
               NpcTipDialog.show("只有" + TextFormatUtil.getRedTxt("超能NoNo") + "的帮助下，赛尔们才能进入暗黑之门，接受新的挑战。快为你的NoNo充能，让它成为超能NoNo吧！",null,NpcTipDialog.NONO);
               return;
            }
            ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.onList);
            ItemManager.getCollection();
         }
      }
      
      private function onList(e:ItemEvent) : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onList);
         var info:SingleItemInfo = ItemManager.getCollectionInfo(this._collId);
         if(info == null)
         {
            Alarm.show("你没有" + TextFormatUtil.getRedTxt("暗黑之钥") + "不能进入暗黑空间！");
         }
         else
         {
            DarkPortalModel.curDoor = this._doorIndex;
            DarkPortalModel.showDoor(this._doorIndex);
         }
      }
      
      private function onClickHandler(e:MouseEvent) : void
      {
         NpcTipDialog.showAnswer("欢迎来到暗黑武斗场，你正在开启试炼之门，我是被赋予了反物质力量的守门精灵！你确定现在就开始接受我的试炼吗？",function():void
         {
            conLevel["monsterMc"].removeEventListener(MouseEvent.MOUSE_OVER,onOverHandler);
            conLevel["monsterMc"].removeEventListener(MouseEvent.MOUSE_OUT,onOutHandler);
            conLevel["monsterMc"].gotoAndStop(3);
            _timer = setTimeout(onTimerOutHandler,1650);
         },null,NpcTipDialog.DARKPET);
      }
      
      private function onTimerOutHandler() : void
      {
         clearTimeout(this._timer);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(this._petId),this.onPetComHandler,"pet");
      }
      
      private function onPetComHandler(mc:DisplayObject) : void
      {
         if(Boolean(mc))
         {
            this._perMc = mc as MovieClip;
            depthLevel.addChild(this._perMc);
            this._perMc.x = this._point.x;
            this._perMc.y = this._point.y;
            this._perMc.scaleX = 1.8;
            this._perMc.scaleY = 1.8;
            ToolTipManager.add(this._perMc,PetXMLInfo.getName(this._petId));
            this._perMc.addEventListener(MouseEvent.CLICK,this.onPetClickHandler);
            this._perMc.buttonMode = true;
            conLevel["monsterMc"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
            conLevel["monsterMc"].visible = false;
         }
      }
      
      private function onPetClickHandler(e:MouseEvent) : void
      {
         this._perMc.removeEventListener(MouseEvent.CLICK,this.onPetClickHandler);
         setTimeout(function():void
         {
            if(Boolean(_perMc))
            {
               _perMc.addEventListener(MouseEvent.CLICK,onPetClickHandler);
            }
         },1000);
         EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
         SocketConnection.send(CommandID.CHALLENGE_BOSS,0);
      }
      
      private function onCloseFight(e:PetFightEvent) : void
      {
         var fightData:FightOverInfo = e.dataObj["data"];
         if(fightData.winnerID == MainManager.actorInfo.userID)
         {
            if(MainManager.actorInfo.superNono == false)
            {
            }
         }
      }
      
      public function onEnterDoorHandler() : void
      {
         MapManager.changeLocalMap(503);
      }
      
      override public function destroy() : void
      {
         this._so = null;
         if(Boolean(this._perMc))
         {
            this._perMc.removeEventListener(MouseEvent.CLICK,this.onPetClickHandler);
            DisplayUtil.removeForParent(this._perMc);
            this._perMc = null;
         }
         conLevel["monsterMc"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         for(var i1:int = 0; i1 < this._lenght; i1++)
         {
            conLevel["darkMc_" + i1].removeEventListener(MouseEvent.CLICK,this.onDoorMcClickHandler);
         }
         conLevel["monsterMc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         conLevel["monsterMc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         ToolTipManager.remove(conLevel["monsterMc"]);
         ToolTipManager.remove(conLevel["darkMc_0"]);
         ToolTipManager.remove(conLevel["darkBookMc"]);
         conLevel["darkBookMc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onBookOverHandler);
         conLevel["darkBookMc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onBookOutHandler);
         if(Boolean(this._bookApp))
         {
            this._bookApp.destroy();
            this._bookApp = null;
         }
         DarkPortalModel.destroy();
      }
   }
}

