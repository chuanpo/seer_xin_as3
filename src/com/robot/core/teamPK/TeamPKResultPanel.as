package com.robot.core.teamPK
{
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.teamPK.TeamPKResultInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.manager.UserInfoManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TeamPKResultPanel extends Sprite
   {
      private var _mainUI:MovieClip;
      
      private var _up_mc:MovieClip;
      
      private var _r_mc:MovieClip;
      
      private var _back_bar:MovieClip;
      
      private var _out_btn:SimpleButton;
      
      private var _taobao_mc:MovieClip;
      
      public function TeamPKResultPanel()
      {
         super();
      }
      
      public function setup(data:TeamPKResultInfo) : void
      {
         TeamPKManager.removeIcon();
         this._mainUI = ShotBehaviorManager.getMovieClip("TeamPKResult_panel");
         this._up_mc = this._mainUI["up_mc"];
         this._r_mc = this._mainUI["r_mc"];
         this._back_bar = this._mainUI["back_bar"];
         this._out_btn = this._mainUI["out_btn"];
         this._taobao_mc = this._mainUI["taobao_mc"];
         if(data.flag == 1)
         {
            this._taobao_mc.visible = false;
         }
         this.setSimpInfo(data.killPlayer,data.killBuilding,data.freezTimes,data.getBadge,data.getExp,data.getCoins);
         MainManager.actorInfo.fightBadge += data.getBadge;
         this.setMcRe(data.result);
         this.setMvp(data.mvpUID);
         this._out_btn.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._mainUI.x = (MainManager.getStage().stageWidth - this._mainUI.width) / 2;
         this._mainUI.y = (MainManager.getStage().stageHeight - this._mainUI.height) / 2;
         LevelManager.topLevel.addChild(this._mainUI);
         LevelManager.closeMouseEvent();
      }
      
      private function destroy() : void
      {
         LevelManager.topLevel.removeChild(this._mainUI);
         LevelManager.openMouseEvent();
         this._mainUI = null;
         this._up_mc = null;
         this._r_mc = null;
         this._back_bar = null;
         this._out_btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this._out_btn = null;
         this._taobao_mc = null;
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         this.destroy();
         TeamPKManager.outTeamMap();
      }
      
      private function setSimpInfo(n0:int, n1:int, n2:int, n3:int, n4:int, n5:int) : void
      {
         this._mainUI["killSeer_txt"].text = String(n0);
         this._mainUI["killBuilding_txt"].text = String(n1);
         this._mainUI["readyNum_txt"].text = String(n2);
         this._mainUI["score_txt"].text = String(n0 * 25 + n1 * 50);
         this._mainUI["zh_txt"].text = String(n3);
         this._mainUI["allScore_txt"].text = String(n4);
         this._mainUI["allMoney_txt"].text = String(n5);
         MainManager.actorInfo.coins += n5;
         if(TeamPKManager.TEAM == TeamPKManager.HOME)
         {
            this._r_mc.gotoAndStop(1);
         }
         else
         {
            this._r_mc.gotoAndStop(2);
         }
      }
      
      private function setMvp(n:uint) : void
      {
         var name:String = null;
         if(n == 0)
         {
            this._mainUI["name_txt"].text = "没有产生";
            this._mainUI["myNum_txt"].text = "";
            return;
         }
         UserInfoManager.getInfo(n,function(info:UserInfo):void
         {
            name = info.nick;
            _mainUI["name_txt"].text = name;
         });
         this._mainUI["myNum_txt"].text = "(" + String(n) + ")";
      }
      
      private function setMcRe(n:uint) : void
      {
         if(TeamPKManager.TEAM == TeamPKManager.HOME)
         {
            if(n == 0)
            {
               this._up_mc.gotoAndStop(2);
               this._back_bar.gotoAndStop(2);
            }
            else if(n == 1)
            {
               this._up_mc.gotoAndStop(1);
               this._back_bar.gotoAndStop(1);
            }
            else if(n == 2)
            {
               this._up_mc.gotoAndStop(3);
               this._back_bar.gotoAndStop(2);
            }
         }
         else if(n == 0)
         {
            this._up_mc.gotoAndStop(1);
            this._back_bar.gotoAndStop(1);
         }
         else
         {
            this._up_mc.gotoAndStop(2);
            this._back_bar.gotoAndStop(2);
         }
      }
   }
}

