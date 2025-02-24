package com.robot.app.mapProcess
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.alert.Alert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_55 extends BaseMapProcess
   {
      private var _js_mc:MovieClip;
      
      private var _jingyanPet:MovieClip;
      
      private var _waterMC:MovieClip;
      
      private var _timer:Timer;
      
      private var _markMc:MovieClip;
      
      private var dong_mc:MovieClip;
      
      private var ding_mc:MovieClip;
      
      public function MapProcess_55()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._waterMC = conLevel["waterMC"];
         ToolTipManager.add(this._waterMC,"露希欧之洋");
         this._markMc = depthLevel["markMc"];
         this._markMc.visible = false;
      }
      
      public function onLineClickHandler() : void
      {
         Alert.show("露希欧之洋出现了涨潮,小赛尔们暂时无法进入。");
      }
      
      public function url() : void
      {
         var r:VipSession = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
         {
         });
         r.getSession();
      }
      
      private function onMarkClickHandler(e:MouseEvent) : void
      {
         NpcTipDialog.showAnswer("嗨嗨，小赛尔请留步，听我说说" + TextFormatUtil.getRedTxt("露希欧之洋") + "的秘密吧！",function():void
         {
            NpcTipDialog.show("赛尔历40年1月，侠客开始了新的探险路程，露希欧星真是一颗神奇的星球呀，好多好多的矿产资源丰富得让我眼花缭乱！",function():void
            {
               NpcTipDialog.show("这里是露希欧之洋的入口，我只悄悄告诉你哦，快去看看神奇的大洋之底吧！",null,NpcTipDialog.NONO);
            },NpcTipDialog.NONO);
         },null,NpcTipDialog.NONO);
      }
      
      override public function destroy() : void
      {
         MainManager.actorModel.visible = true;
      }
   }
}

