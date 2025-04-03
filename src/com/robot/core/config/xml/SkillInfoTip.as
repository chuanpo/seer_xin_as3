package com.robot.core.ui.skillBtn
{
   import com.robot.core.config.xml.SkillXMLInfo;
   import com.robot.core.info.skillEffectInfo.EffectInfoManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;

   public class SkillInfoTip
   {
      private static var tipMC:MovieClip;

      private static var timer:Timer;

      setup();

      public function SkillInfoTip()
      {
         super();
      }

      private static function setup():void
      {
         timer = new Timer(5000, 1);
         timer.addEventListener(TimerEvent.TIMER, timerHandler);
      }

      public static function show(_id:uint):void
      {
         var color:String = null;
         var i:String = null;
         var txt:TextField = null;
         var num:uint = 0;
         var tempNum:uint = 0;
         var des:String = null;
         if (!tipMC)
         {
            tipMC = UIManager.getMovieClip("ui_SkillTipPanel");
            tipMC.mouseChildren = false;
            tipMC.mouseEnabled = false;
         }
         timer.stop();
         timer.reset();
         var name:String = SkillXMLInfo.getName(_id);
         var category:uint = uint(SkillXMLInfo.getCategory(_id));
         var sideEffects:Array = SkillXMLInfo.getSideEffects(_id);
         var sideEffectsArgs:Array = SkillXMLInfo.getSideEffectArgs(_id);
         if (category == 1)
         {
            color = "#FF0000";
         }
         else if (category == 2)
         {
            color = "#FF99FF";
         }
         else
         {
            color = "#99ff00";
         }
         var str:String = "<font color=\'#ffff00\'>" + name + "</font>  " + "<font color=\'" + color + "\'>(" + SkillXMLInfo.getCategoryName(_id) + ")</font>\r";
         var argsNum:uint = 0;
         str += "\r";

         // 威力（Damage）
         var mig:Number = SkillXMLInfo.getDamage(_id);
         if (category == 1 | category == 2)
         {
            str += "威力：" + mig + "\r";
         }

         // 会心率（CritRate）
         var critRate:int = SkillXMLInfo.getCritRate(_id);
         if (critRate > 0)
         {
            str += "会心率：" + Number(critRate/16*100) + "%\r";
         }

         // 先制（Priority）
         var priority:int = SkillXMLInfo.getPriority(_id);
         if (priority != 0)
         {
            if (priority > 0)
            {
               str += "先制+" + priority + "\r";
            }
            else
            {
               str += "先制" + priority + "\r";
            }
         }

         // 命中率（Accuracy）
         var accuracy:Number = SkillXMLInfo.hitP(_id);
         var mustHit:Number = SkillXMLInfo.getMustHit(_id);
         if (mustHit == 1)
         {
            str += "必中";
         }
         else
         {
            str += "命中率：" + accuracy + "%";
         }

         //技能效果（SideEffects）
         var pwrBindDv:Number = SkillXMLInfo.getPwrBindDv(_id);
         str += "\r";
         try
         {
            for each (i in sideEffects)
            {
               if (pwrBindDv == 1)
               {
                  str += "\r威力=自身个体值*5";
               }
               else if (i != "")
               {
                  num = uint(1000000 + uint(i));
                  tempNum = EffectInfoManager.getArgsNum(uint(i));
                  des = EffectInfoManager.getInfo(uint(i), sideEffectsArgs.slice(argsNum, argsNum + tempNum));
                  argsNum += tempNum;
                  str += "\r" + des;
               }
            }
         }
         catch (e:Error)
         {
         }

         txt = tipMC["info_txt"];
         txt.autoSize = TextFieldAutoSize.LEFT;
         txt.wordWrap = true;
         txt.htmlText = str;
         tipMC["bgMC"].height = txt.height + 20;
         tipMC["bgMC"].width = txt.width + 20;
         MainManager.getStage().addChild(tipMC);
         tipMC.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
         timer.start();
      }

      private static function timerHandler(event:TimerEvent):void
      {
         hide();
      }

      public static function hide():void
      {
         if (Boolean(tipMC))
         {
            tipMC.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            DisplayUtil.removeForParent(tipMC);
         }
      }

      private static function enterFrameHandler(event:Event):void
      {
         if (MainManager.getStage().mouseX + tipMC.width + 20 >= MainManager.getStageWidth())
         {
            tipMC.x = MainManager.getStageWidth() - tipMC.width - 10;
         }
         else
         {
            tipMC.x = MainManager.getStage().mouseX + 10;
         }
         if (MainManager.getStage().mouseY + tipMC.height + 20 >= MainManager.getStageHeight())
         {
            tipMC.y = MainManager.getStageHeight() - tipMC.height - 10;
         }
         else
         {
            tipMC.y = MainManager.getStage().mouseY + 20;
         }
      }
   }
}
