package com.robot.app.RegisterCode
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.CommandID;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class CopyRegisterCodePanel
   {
      private static var mc:MovieClip;
      
      private static var app:ApplicationDomain;
      
      private static var closeBtn:SimpleButton;
      
      private static var copyBtn:SimpleButton;
      
      private static var exchangeBtn:SimpleButton;
      
      private static var PATH:String = "resource/module/RequestCode/registerCode.swf";
      
      public function CopyRegisterCodePanel()
      {
         super();
      }
      
      public static function loadPanel() : void
      {
         var loader:MCLoader = null;
         if(!mc)
         {
            loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在打开邀请码面板");
            loader.addEventListener(MCLoadEvent.SUCCESS,onLoad);
            loader.doLoad();
         }
         else
         {
            mc.gotoAndStop(1);
            show();
         }
      }
      
      private static function onLoad(event:MCLoadEvent) : void
      {
         app = event.getApplicationDomain();
         mc = new (app.getDefinition("codePanel") as Class)() as MovieClip;
         show();
      }
      
      private static function show() : void
      {
         var dragMc:SimpleButton;
         var codeTxt:TextField;
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mc);
         closeBtn = mc["exitBtn"];
         copyBtn = mc["copyBtn"];
         exchangeBtn = mc["exchangeBtn"];
         dragMc = mc["dragMC"];
         dragMc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            mc.startDrag();
         });
         dragMc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            mc.stopDrag();
         });
         codeTxt = mc["codeTxt"];
         codeTxt.text = GetRegisterCode.getRegCode.toString();
         exchangeBtn.addEventListener(MouseEvent.CLICK,getRequstAward);
         closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
         copyBtn.addEventListener(MouseEvent.CLICK,copyContent);
         SocketConnection.addCmdListener(CommandID.REQUEST_COUNT,onCount);
         SocketConnection.send(CommandID.REQUEST_COUNT,MainManager.actorID);
      }
      
      private static function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
         closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function copyContent(e:MouseEvent) : void
      {
         var str:String = "我正在赛尔号上进行太空探险，带着我的精灵在各个星球上战斗，他们还会进化呢。快和我一起来吧，www.51seer.com 注册的邀请码是" + GetRegisterCode.getRegCode.toString() + "。我们赛尔号上见！";
         System.setClipboard(str);
      }
      
      private static function getRequstAward(e:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_REQUEST_AWARD,onGetAward);
         SocketConnection.send(CommandID.GET_REQUEST_AWARD);
      }
      
      private static function onGetAward(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_REQUEST_AWARD,onGetAward);
         NpcTipDialog.show("恭喜你成为合格的星际联络官，联络官套装已经放入了你的储存箱");
      }
      
      private static function onCount(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.REQUEST_COUNT,onCount);
         var byteAry:ByteArray = event.data as ByteArray;
         var useId:uint = byteAry.readUnsignedInt();
         var requestCount:uint = byteAry.readUnsignedInt();
         mc["countTxt"].text = requestCount.toString();
      }
   }
}

