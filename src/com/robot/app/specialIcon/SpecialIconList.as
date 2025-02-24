package com.robot.app.specialIcon
{
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   
   public class SpecialIconList extends Sprite
   {
      private var mainUI:Sprite;
      
      private var desNonoBtn:SimpleButton;
      
      private var openNono:SimpleButton;
      
      private var cashBtn:SimpleButton;
      
      private var callNonoBtn:SimpleButton;
      
      private var salePlaceBtn:SimpleButton;
      
      private var viewMyCount:SimpleButton;
      
      private var setPassWord:SimpleButton;
      
      private var mimiCardBtn:SimpleButton;
      
      private var closeBtn:SimpleButton;
      
      private var _nonoIntrolPanel:AppModel;
      
      public function SpecialIconList()
      {
         super();
         this.mainUI = TaskIconManager.getIcon("ui_SuperNonoSubPanel") as Sprite;
         this.desNonoBtn = this.mainUI["desNono"];
         this.openNono = this.mainUI["openNono"];
         this.cashBtn = this.mainUI["cashBtn"];
         this.callNonoBtn = this.mainUI["callNono"];
         this.salePlaceBtn = this.mainUI["salePlaceBtn"];
         this.viewMyCount = this.mainUI["viewCountBtn"];
         this.setPassWord = this.mainUI["setPassWordBtn"];
         this.closeBtn = this.mainUI["closeBtn"];
         this.mimiCardBtn = this.mainUI["mimicardBtn"];
         addChild(this.mainUI);
      }
      
      private function addEvent() : void
      {
         this.desNonoBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.openNono.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.cashBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.callNonoBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.salePlaceBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.viewMyCount.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.setPassWord.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.mimiCardBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
      }
      
      private function removeEvent() : void
      {
         this.desNonoBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.openNono.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.cashBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.callNonoBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.salePlaceBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.viewMyCount.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.setPassWord.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this.mimiCardBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
      }
      
      private function onMouseClickHandler(e:MouseEvent) : void
      {
         var r:VipSession = new VipSession();
         switch(e.currentTarget.name)
         {
            case "desNono":
               if(!this._nonoIntrolPanel)
               {
                  this._nonoIntrolPanel = new AppModel(ClientConfig.getAppModule("IntrolNonoPanel"),"正在打开超能NoNo介绍面板");
                  this._nonoIntrolPanel.setup();
               }
               this._nonoIntrolPanel.show();
               break;
            case "callNono":
               if(MainManager.actorModel.nono == null)
               {
                  if(!MainManager.actorInfo.vip && Boolean(MainManager.actorInfo.viped))
                  {
                     Alarm.show("你的超能NoNo失去了超级能力，无法使用此功能哦！");
                     return;
                  }
                  if(!MainManager.actorInfo.superNono)
                  {
                     Alarm.show("只有超能NoNo才能被召唤哦");
                     return;
                  }
                  NonoManager.isBeckon = true;
                  SocketConnection.send(CommandID.NONO_FOLLOW_OR_HOOM,1);
                  this.hide();
               }
               break;
            default:
               Alarm.show("此功能暂不开放");
         }
      }
      
      public function show(dis:DisplayObject) : void
      {
         var p:Point = dis.localToGlobal(new Point());
         this.x = p.x - 220;
         this.y = p.y - this.height + 85;
         LevelManager.toolsLevel.addChild(this);
         this.addEvent();
      }
      
      public function hide() : void
      {
         dispatchEvent(new Event(Event.CLOSE));
         this.removeEvent();
         DisplayUtil.removeForParent(this);
      }
   }
}

