package com.robot.app.cmd
{
   import com.robot.app.mapProcess.MapProcess_107;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.info.SystemMsgInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class VipNotManager
   {
      private var npcMC:Sprite;
      
      private var npcLink:Array = [""];
      
      private var npcName:Array = ["","船长罗杰","机械师茜茜","博士派特","导航员爱丽丝","站长贾斯汀","诺诺","发明家肖恩"];
      
      private var panel:MovieClip;
      
      private var callBtn:SimpleButton;
      
      private var continueBtn:SimpleButton;
      
      private var goNowBtn:SimpleButton;
      
      public function VipNotManager()
      {
         super();
         this.npcLink.push(NpcTipDialog.SHIPER);
         this.npcLink.push(NpcTipDialog.CICI);
         this.npcLink.push(NpcTipDialog.DOCTOR);
         this.npcLink.push(NpcTipDialog.IRIS);
         this.npcLink.push(NpcTipDialog.JUSTIN);
         this.npcLink.push(NpcTipDialog.NONO);
         this.npcLink.push(NpcTipDialog.SHAWN);
      }
      
      public function goNow(data:SystemMsgInfo) : void
      {
         this.goNowBtn = new lib_goNowBtn();
         this.goNowBtn.addEventListener(MouseEvent.CLICK,this.goNowHandler);
         this.show(this.goNowBtn,data,false);
         LevelManager.closeMouseEvent();
      }
      
      public function openAgain(data:SystemMsgInfo) : void
      {
         this.callBtn = new lib_callBtn();
         this.callBtn.addEventListener(MouseEvent.CLICK,this.callHandler);
         this.show(this.callBtn,data);
      }
      
      public function cancelHandler(data:SystemMsgInfo) : void
      {
         this.continueBtn = new lib_continueBtn();
         this.continueBtn.addEventListener(MouseEvent.CLICK,this.continueHandler);
         this.show(this.continueBtn,data);
      }
      
      private function goNowHandler(event:MouseEvent) : void
      {
         LevelManager.openMouseEvent();
         DisplayUtil.removeForParent(this.goNowBtn);
         DisplayUtil.removeForParent(this.panel,false);
         MapProcess_107.isOpenSuperNoNo = true;
         MapManager.changeMap(107);
      }
      
      private function callHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.callBtn);
         DisplayUtil.removeForParent(this.panel,false);
         NonoManager.isBeckon = true;
         SocketConnection.send(CommandID.NONO_FOLLOW_OR_HOOM,1);
      }
      
      public function continueHandler(event:MouseEvent) : void
      {
         var r:VipSession;
         DisplayUtil.removeForParent(this.continueBtn);
         DisplayUtil.removeForParent(this.panel,false);
         r = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
         {
         });
         r.getSession();
      }
      
      private function show(dis:DisplayObject, data:SystemMsgInfo, isShowClose:Boolean = true) : void
      {
         var date:Date;
         var str:String;
         this.panel = this.getPanel(isShowClose);
         this.panel["titleTxt"].text = "亲爱的" + MainManager.actorInfo.nick;
         this.panel["msgTxt"].htmlText = data.msg;
         date = new Date(data.msgTime * 1000);
         str = this.npcName[data.npc] + "\r";
         this.panel["timeTxt"].text = str + date.getFullYear() + "年" + (date.getMonth() + 1) + "月" + date.getDate() + "日";
         ResourceManager.getResource(ClientConfig.getNpcSwfPath(this.npcLink[data.npc]),function(o:DisplayObject):void
         {
            npcMC.addChild(o);
         },"npc");
         trace("-------------",ClientConfig.getNpcSwfPath(this.npcLink[data.npc]));
         LevelManager.topLevel.addChild(this.panel);
         this.panel.addChild(dis);
         DisplayUtil.align(dis,this.panel.getRect(this.panel),AlignType.BOTTOM_CENTER);
         dis.y -= 30;
      }
      
      private function getPanel(isShowClose:Boolean = true) : MovieClip
      {
         var mc:MovieClip = UIManager.getMovieClip("ui_SysMsg_Panel");
         var closeBtn:SimpleButton = mc["closeBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         if(!isShowClose)
         {
            DisplayUtil.removeForParent(closeBtn);
         }
         this.npcMC = new Sprite();
         this.npcMC.scaleY = 0.65;
         this.npcMC.scaleX = 0.65;
         this.npcMC.x = 50;
         this.npcMC.y = 86;
         mc.addChild(this.npcMC);
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
         return mc;
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.panel,false);
         DisplayUtil.removeAllChild(this.npcMC);
      }
   }
}

