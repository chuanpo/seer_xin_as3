package com.robot.app.automaticFight
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.CommandID;
   import com.robot.core.event.PetEvent;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.fightInfo.PetFightModel;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.LeftToolBarManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.component.bgFill.SoildFillStyle;
   import org.taomee.component.containers.VBox;
   import org.taomee.component.control.MLabel;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class AutomaticFightManager
   {
      private static var times:uint;
      
      private static var icon:MovieClip;
      
      private static var tipMC:VBox;
      
      private static var txt:TextField;
      
      private static var fightTipMC:MovieClip;
      
      private static var stateLabel:MLabel;
      
      private static var redLabel:MLabel;
      
      public static const ON:uint = 1;
      
      public static const OFF:uint = 0;
      
      private static var _isClear:Boolean = true;
      
      private static var isCanOnOff:Boolean = true;
      
      private static var isStopBuf:Boolean = false;
      
      public function AutomaticFightManager()
      {
         super();
      }
      
      public static function showFightTips() : void
      {
         var btn:SimpleButton = null;
         if(!fightTipMC)
         {
            fightTipMC = new lib_fightTip_mc();
            btn = fightTipMC["stopBtn"];
            btn.addEventListener(MouseEvent.CLICK,closeTipMC);
            DisplayUtil.align(fightTipMC,null,AlignType.MIDDLE_CENTER);
         }
         fightTipMC["txt"].text = MainManager.actorInfo.autoFightTimes.toString();
         MainManager.getStage().addChild(fightTipMC);
      }
      
      private static function closeTipMC(event:MouseEvent) : void
      {
         isStopBuf = true;
         DisplayUtil.removeForParent(fightTipMC);
      }
      
      public static function subTimes() : void
      {
         if(MainManager.actorInfo.autoFightTimes > 0)
         {
            --MainManager.actorInfo.autoFightTimes;
         }
         showFightTips();
      }
      
      public static function setup() : void
      {
         if(!icon)
         {
            getTipMC();
            icon = TaskIconManager.getIcon("autoFight_icon") as MovieClip;
            icon.gotoAndStop(1);
            icon.filters = [ColorFilter.setGrayscale(),new DropShadowFilter()];
            icon.buttonMode = true;
            icon.addEventListener(MouseEvent.CLICK,clickIocn);
            icon.addEventListener(MouseEvent.ROLL_OVER,overIcon);
            icon.addEventListener(MouseEvent.ROLL_OUT,outIcon);
            icon.mouseChildren = false;
            txt = icon["txt"];
         }
         checkIcon();
         if(isStart)
         {
            icon.gotoAndStop(2);
            icon.filters = [new DropShadowFilter()];
            EventManager.addEventListener(PetFightEvent.FIGHT_RESULT,onFightOver);
            PetManager.addEventListener(PetEvent.UPDATE_INFO,onUpdateInfo);
         }
         EventManager.addEventListener(RobotEvent.AUTO_FIGHT_CHANGE,onAutoFightChange);
      }
      
      private static function onAutoFightChange(event:RobotEvent) : void
      {
         txt.text = MainManager.actorInfo.autoFightTimes.toString();
         if(MainManager.actorInfo.autoFightTimes == 0)
         {
            hideIcon();
         }
      }
      
      public static function useItem(itemID:uint) : void
      {
         SocketConnection.removeCmdListener(CommandID.USE_AUTO_FIGHT_ITEM,onUseItem);
         SocketConnection.addCmdListener(CommandID.USE_AUTO_FIGHT_ITEM,onUseItem);
         SocketConnection.send(CommandID.USE_AUTO_FIGHT_ITEM,itemID);
      }
      
      private static function onUseItem(event:SocketEvent) : void
      {
         var data:ByteArray = event.data as ByteArray;
         MainManager.actorInfo.autoFight = data.readUnsignedInt();
         MainManager.actorInfo.autoFightTimes = data.readUnsignedInt();
         checkIcon();
      }
      
      private static function showIcon() : void
      {
         txt.text = MainManager.actorInfo.autoFightTimes.toString();
         LeftToolBarManager.addIcon(icon);
      }
      
      public static function hideIcon() : void
      {
         LeftToolBarManager.delIcon(icon);
      }
      
      private static function setOnOff(flag:uint) : void
      {
         isCanOnOff = false;
         SocketConnection.removeCmdListener(CommandID.ON_OFF_AUTO_FIGHT,onSetAutoFight);
         SocketConnection.addCmdListener(CommandID.ON_OFF_AUTO_FIGHT,onSetAutoFight);
         SocketConnection.send(CommandID.ON_OFF_AUTO_FIGHT,flag);
      }
      
      private static function onSetAutoFight(event:SocketEvent) : void
      {
         if(isStopBuf)
         {
            isStopBuf = false;
            _isClear = true;
         }
         var data:ByteArray = event.data as ByteArray;
         MainManager.actorInfo.autoFight = data.readUnsignedInt();
         MainManager.actorInfo.autoFightTimes = data.readUnsignedInt();
         if(isStart)
         {
            icon.gotoAndStop(2);
            icon.filters = [new DropShadowFilter()];
            EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onFightOver);
            PetManager.addEventListener(PetEvent.UPDATE_INFO,onUpdateInfo);
         }
         else
         {
            icon.gotoAndStop(1);
            icon.filters = [ColorFilter.setGrayscale(),new DropShadowFilter()];
            EventManager.removeEventListener(PetFightEvent.FIGHT_RESULT,onFightOver);
            PetManager.removeEventListener(PetEvent.UPDATE_INFO,onUpdateInfo);
         }
         isCanOnOff = true;
      }
      
      private static function checkIcon() : void
      {
         if(MainManager.actorInfo.autoFight > 0)
         {
            showIcon();
         }
         else
         {
            hideIcon();
         }
      }
      
      private static function clickIocn(event:MouseEvent) : void
      {
         if(!isCanOnOff)
         {
            return;
         }
         if(MainManager.actorInfo.autoFight == 3)
         {
            setOnOff(0);
         }
         else
         {
            setOnOff(1);
         }
      }
      
      private static function overIcon(event:MouseEvent) : void
      {
         var p:Point = icon.localToGlobal(new Point());
         tipMC.x = p.x + 35;
         tipMC.y = p.y + 45;
         if(MainManager.actorInfo.autoFight != 3)
         {
            stateLabel.textColor = 13421772;
            stateLabel.text = "未开启状态";
            redLabel.text = "点击可开启该装置";
         }
         else
         {
            stateLabel.textColor = 52224;
            stateLabel.text = "开启状态";
            redLabel.text = "点击可开关闭装置";
         }
         LevelManager.iconLevel.addChild(tipMC);
      }
      
      private static function outIcon(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(tipMC);
      }
      
      public static function get isStart() : Boolean
      {
         if(isStopBuf)
         {
            return false;
         }
         return MainManager.actorInfo.autoFightTimes > 0 && MainManager.actorInfo.autoFight == 3;
      }
      
      public static function get isClear() : Boolean
      {
         return _isClear;
      }
      
      public static function beginFight(index:uint, id:uint) : void
      {
         var p:PetInfo = null;
         var num:uint = 0;
         var s:PetSkillInfo = null;
         if(!isStart || !isClear)
         {
            return;
         }
         if(PetManager.length == 0)
         {
            Alarm.show("你的背包里还没有一只赛尔精灵哦！");
            return;
         }
         var petList:Array = PetManager.infos;
         for each(p in petList)
         {
            num = 0;
            for each(s in p.skillArray)
            {
               num += s.pp;
            }
            if(p.hp > 0 && num > 0)
            {
               MainManager.actorModel.stop();
               LevelManager.closeMouseEvent();
               PetFightModel.defaultNpcID = id;
               FightInviteManager.fightWithNpc(index);
               return;
            }
         }
         Alarm.show("你的赛尔精灵没有体力或不能使用技能了，不能出战哦！");
      }
      
      public static function fightOver(bmp:Bitmap) : void
      {
         DisplayUtil.removeForParent(bmp);
         PetManager.upDate();
      }
      
      private static function onFightOver(event:PetFightEvent) : void
      {
         if(isStopBuf)
         {
            setOnOff(0);
         }
         _isClear = false;
         DisplayUtil.removeForParent(fightTipMC);
      }
      
      private static function onUpdateInfo(event:PetEvent) : void
      {
         var _listData:Array = null;
         var info:PetInfo = null;
         _isClear = true;
         if(isStart)
         {
            _listData = PetManager.infos;
            _listData.sortOn("isDefault",Array.DESCENDING);
            info = _listData[0];
            if(info.hp <= info.maxHp / 2)
            {
               PetManager.cureAll(false);
            }
         }
      }
      
      private static function getTipMC() : void
      {
         tipMC = new VBox(-2);
         tipMC.setSizeWH(140,70);
         tipMC.halign = FlowLayout.CENTER;
         tipMC.valign = FlowLayout.MIDLLE;
         tipMC.bgFillStyle = new SoildFillStyle(0,0.8,20,20);
         var label:MLabel = new MLabel("自动战斗器S型");
         label.width = 120;
         label.textColor = 52224;
         label.blod = true;
         stateLabel = new MLabel();
         stateLabel.textColor = 52224;
         redLabel = new MLabel();
         redLabel.textColor = 16776960;
         stateLabel.fontSize = redLabel.fontSize = 12;
         stateLabel.width = redLabel.width = 120;
         tipMC.appendAll(label,stateLabel,redLabel);
      }
   }
}

