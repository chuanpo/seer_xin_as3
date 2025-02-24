package com.robot.app.mapProcess
{
   import com.robot.app.protectSys.ProtectSystem;
   import com.robot.app.toolBar.ToolBarController;
   import com.robot.app.toolBar.pkTool.TeamPkTool;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.teamPK.TeamPKManager;
   import com.robot.core.teamPK.TeamPKMyHpPanel;
   import com.robot.core.teamPK.shotActive.AutoShotManager;
   import com.robot.core.ui.alert.Answer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Timer;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.control.UIMovieClip;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.manager.ToolTipManager;
   
   public class PkMapBase extends BaseMapProcess
   {
      private var _teamPKST_icon:InteractiveObject;
      
      private var _teamPkSt_panel:AppModel;
      
      private var _radius:uint;
      
      private var _teaminfo_panel:MovieClip;
      
      private var _homeScore_txt:TextField;
      
      private var _awayScore_txt:TextField;
      
      private var _time_txt:TextField;
      
      private var _time:Timer;
      
      private var _mySt_panel:TeamPKMyHpPanel;
      
      private var _go_0:MovieClip;
      
      private var _go_1:MovieClip;
      
      private var box:HBox;
      
      private var quitBtn:SimpleButton;
      
      private var firstLogin:Boolean = true;
      
      public function PkMapBase()
      {
         var _point:Point = null;
         super();
         ProtectSystem.canShow = false;
         LevelManager.iconLevel.visible = false;
         this.box = new HBox(30);
         this.box.halign = FlowLayout.RIGHT;
         this.box.valign = FlowLayout.MIDLLE;
         this.box.setSizeWH(950,70);
         this._go_0 = conLevel["go1_mc"];
         this._go_1 = conLevel["go2_mc"];
         this._go_0.gotoAndStop(1);
         this._go_1.gotoAndStop(1);
         TeamPkTool.instance.show();
         TeamPkTool.instance.open();
         AutoShotManager.setup();
         if(TeamPKManager.TEAM == TeamPKManager.AWAY)
         {
            _point = new Point(MainManager.actorModel.pos.x + TeamPKManager.REDX,MainManager.actorModel.pos.y);
            MainManager.actorModel.x = _point.x;
            MainManager.actorModel.walkAction(_point);
            _point = null;
            LevelManager.moveToRight();
            MainManager.actorModel.additiveInfo.info = TeamPKManager.AWAY;
         }
         else
         {
            MainManager.actorModel.additiveInfo.info = TeamPKManager.HOME;
         }
         LevelManager.topLevel.addChild(this.box);
         this._teamPKST_icon = TaskIconManager.getIcon("TeamPkSt_icon");
         LevelManager.iconLevel.addChild(this._teamPKST_icon);
         ToolTipManager.add(this._teamPKST_icon,"战队战况");
         this._teamPKST_icon.addEventListener(MouseEvent.CLICK,this.clickPkStHandler);
         this.quitBtn = ShotBehaviorManager.getButton("pk_quit_btn");
         this.quitBtn.addEventListener(MouseEvent.CLICK,this.quit);
         ToolTipManager.add(this.quitBtn,"离开战场");
         this.box.append(new UIMovieClip(this._teamPKST_icon));
         this.box.append(new UIMovieClip(this.quitBtn));
         ToolBarController.aimatOff();
         ToolBarController.bagOff();
         ToolBarController.homeOff();
         ToolBarController.panel.closeMap();
         this._teaminfo_panel = ShotBehaviorManager.getMovieClip("TeamPkInfoPanel");
         this._homeScore_txt = this._teaminfo_panel["homeScore_txt"];
         this._awayScore_txt = this._teaminfo_panel["awayScore_txt"];
         this._time_txt = this._teaminfo_panel["time_txt"];
         this._teaminfo_panel.x = (MainManager.getStage().stageWidth - this._teaminfo_panel.width) / 2;
         this._teaminfo_panel.y = 5;
         LevelManager.topLevel.addChild(this._teaminfo_panel);
         this._mySt_panel = new TeamPKMyHpPanel();
         this._mySt_panel.setup();
         this._mySt_panel.show();
      }
      
      private function quit(event:MouseEvent) : void
      {
         Answer.show("现在离开战场将无法返回本场保卫战，你确定要离开吗？",this.quitMap);
      }
      
      private function quitMap() : void
      {
         TeamPKManager.levelMapInt();
         MapManager.changeMap(1);
      }
      
      private function clickPkStHandler(e:MouseEvent) : void
      {
         TeamPKManager.getTeamSituation();
         TeamPKManager.isShowPanel = true;
      }
      
      override protected function init() : void
      {
      }
      
      override public function destroy() : void
      {
      }
   }
}

