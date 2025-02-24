package com.robot.app.task.pioneerTaskList
{
   import com.robot.app.buyItem.ItemAction;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.newloader.MCLoader;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class HOTestTask extends Sprite
   {
      private const url_str:String = "resource/Games/HOTestTaskGame.swf";
      
      private var uiLoader:MCLoader;
      
      private var app:ApplicationDomain;
      
      private var mainUI_mc:Sprite;
      
      private var addNum:Number = 0.02;
      
      private var o2_num:Number = 0;
      
      private var h2_num:Number = 0;
      
      private var time:uint = 0;
      
      private var isTask_b:Boolean;
      
      private var dd:*;
      
      private var bili_num:Number;
      
      private var nn:String;
      
      private var timer:uint;
      
      private var timer1:uint;
      
      public function HOTestTask(isTask:Boolean = true)
      {
         super();
         this.isTask_b = isTask;
         LevelManager.topLevel.addChild(this);
         this.loadAssets(this.url_str);
      }
      
      private function loadAssets(s1:String) : void
      {
         this.dd = UIManager.getMovieClip("doctor");
         this.uiLoader = new MCLoader(s1,LevelManager.appLevel,1,"正在打开任务");
         this.uiLoader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadUISuccessHandler);
         this.uiLoader.doLoad();
      }
      
      private function onLoadUISuccessHandler(event:MCLoadEvent) : void
      {
         this.app = event.getApplicationDomain();
         this.mainUI_mc = new (this.app.getDefinition("HOTest_MC") as Class)() as Sprite;
         this.addChild(this.mainUI_mc);
         for(var j1:int = 0; j1 < 3; j1++)
         {
            this.mainUI_mc["left" + (j1 + 1)].gotoAndStop(1);
         }
         this.mainUI_mc["gu_mc"].gotoAndStop(1);
         this.mainUI_mc["help_btn"].addEventListener(MouseEvent.CLICK,this.onHelpHandler);
         this.mainUI_mc["exit_btn"].addEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this.mainUI_mc["bigFire_mc"].visible = false;
         this.mainUI_mc["bigFire_mc"].gotoAndStop(1);
         this.mainUI_mc["yan_mc"].visible = false;
         this.mainUI_mc["yan_mc"]["yan"].gotoAndStop(1);
         this.stopPaoPao();
         this.mainUI_mc["addO2_mc"].useHandCursor = true;
         this.mainUI_mc["addO2_mc"].buttonMode = true;
         this.mainUI_mc["addO2_mc"].gotoAndStop(1);
         this.mainUI_mc["addO2_mc"].addEventListener(MouseEvent.MOUSE_OVER,this.onAddO2MouseOverHandler);
         this.mainUI_mc["addH2_mc"].useHandCursor = true;
         this.mainUI_mc["addH2_mc"].buttonMode = true;
         this.mainUI_mc["addH2_mc"].gotoAndStop(1);
         this.mainUI_mc["addH2_mc"].addEventListener(MouseEvent.MOUSE_OVER,this.onAddH2MouseOverHandler);
         this.mainUI_mc["fire_btn"].addEventListener(MouseEvent.CLICK,this.onFireBtnClickHandler);
      }
      
      private function onHelpHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["help_btn"].removeEventListener(MouseEvent.CLICK,this.onHelpHandler);
         NpcTipDialog.show("点击氢气罐和氧气罐的开关控制气体输入量，当你觉得比例合适的，就可以点击那个红色“点火”按钮。氢氧充分燃烧，爆出最大火焰，你才算能正确操作喷火装备。！",this.removeH,this.dd,0,this.removeH);
      }
      
      private function removeH() : void
      {
         this.mainUI_mc["help_btn"].addEventListener(MouseEvent.CLICK,this.onHelpHandler);
      }
      
      private function onCloseHandler(event:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function destroy() : void
      {
         this.first();
         this.mainUI_mc["exit_btn"].removeEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this.mainUI_mc["addO2_mc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onAddO2MouseOverHandler);
         this.mainUI_mc["addH2_mc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onAddH2MouseOverHandler);
         this.mainUI_mc["fire_btn"].removeEventListener(MouseEvent.CLICK,this.onFireBtnClickHandler);
         DisplayUtil.stopAllMovieClip(this.mainUI_mc);
         DisplayUtil.removeForParent(this);
         this.mainUI_mc = null;
         this.uiLoader.clear();
         this.uiLoader = null;
      }
      
      private function first() : void
      {
         this.o2_num = 0;
         this.h2_num = 0;
         this.setO2("");
         this.setH2("");
         this.mainUI_mc["bili_txt"].text = "";
      }
      
      private function onFireBtnClickHandler(event:MouseEvent) : void
      {
         var j1:int = 0;
         this.nn = int(100 * this.o2_num / this.h2_num) + "%";
         if(this.time <= 2)
         {
            ++this.time;
            for(j1 = 0; j1 < this.time; j1++)
            {
               this.mainUI_mc["left" + (j1 + 1)].gotoAndStop(2);
            }
            this.bili_num = this.h2_num / this.o2_num;
            this.bili_num = Number(this.bili_num.toFixed(2));
            if(this.o2_num == 0 && this.h2_num == 0)
            {
               if(this.time == 3)
               {
                  NpcTipDialog.show("氢气和氧气都被你用光了，你还没有找到合适氢氧混合比例，你这次测试失败！等会再找我来参加测试吧！",this.destroy,this.dd,0,this.destroy);
               }
               else
               {
                  NpcTipDialog.show("氧气和氢气的比例是 " + this.nn + " ,这个浓度还不能最充分的燃烧。",this.first,this.dd,0,this.first);
               }
               return;
            }
            if(this.o2_num == 0 && this.h2_num != 0)
            {
               if(this.time == 3)
               {
                  NpcTipDialog.show("氢气和氧气都被你用光了，你还没有找到合适氢氧混合比例，你这次测试失败！等会再找我来参加测试吧！",this.destroy,this.dd,0,this.destroy);
               }
               else
               {
                  NpcTipDialog.show("氧气和氢气的比例是" + this.nn + "这个浓度还不能最充分的燃烧。",this.first,this.dd,0,this.first);
               }
               return;
            }
            if(this.o2_num != 0 && this.h2_num == 0)
            {
               if(this.time == 3)
               {
                  NpcTipDialog.show("氢气和氧气都被你用光了，你还没有找到合适氢氧混合比例，你这次测试失败！等会再找我来参加测试吧！",this.destroy,this.dd,0,this.destroy);
               }
               else
               {
                  NpcTipDialog.show("氧气和氢气的比例是" + this.nn + "这个浓度还不能最充分的燃烧。",this.first,this.dd,0,this.first);
               }
               return;
            }
            if(this.o2_num != 0 && this.h2_num != 0)
            {
               if(this.bili_num > 2.2)
               {
                  this.timer = setTimeout(this.setTime,400);
                  this.mainUI_mc["bigFire_mc"].visible = true;
                  this.mainUI_mc["bigFire_mc"].play();
                  this.mainUI_mc["yan_mc"].visible = true;
                  this.mainUI_mc["yan_mc"]["yan"].play();
                  return;
               }
               if(this.bili_num < 1.8)
               {
                  this.timer = setTimeout(this.setTime,400);
                  this.mainUI_mc["bigFire_mc"].visible = true;
                  this.mainUI_mc["bigFire_mc"].play();
                  this.mainUI_mc["yan_mc"].visible = true;
                  this.mainUI_mc["yan_mc"]["yan"].play();
                  return;
               }
               if(this.bili_num <= 2.2 && this.bili_num >= 1.8)
               {
                  this.mainUI_mc["fire_btn"].removeEventListener(MouseEvent.CLICK,this.onFireBtnClickHandler);
                  this.timer1 = setTimeout(this.setTimer1,400);
                  this.mainUI_mc["bigFire_mc"].visible = true;
                  this.mainUI_mc["bigFire_mc"].play();
                  this.mainUI_mc["yan_mc"].visible = true;
                  this.mainUI_mc["yan_mc"]["yan"].play();
                  return;
               }
            }
         }
      }
      
      private function setTime() : void
      {
         clearTimeout(this.timer);
         this.nn = int(100 * this.o2_num / this.h2_num) + "%";
         this.mainUI_mc["bigFire_mc"].visible = false;
         this.mainUI_mc["bigFire_mc"].gotoAndStop(1);
         this.mainUI_mc["yan_mc"].visible = false;
         this.mainUI_mc["yan_mc"]["yan"].gotoAndStop(1);
         if(this.time == 3)
         {
            NpcTipDialog.show("氢气和氧气都被你用光了，你还没有找到合适氢氧混合比例，你这次测试失败！等会再找我来参加测试吧！",this.destroy,this.dd,0,this.destroy);
         }
         else
         {
            NpcTipDialog.show("氧气和氢气的比例是" + this.nn + "这个浓度还不能最充分的燃烧。",this.first,this.dd,0,this.first);
         }
      }
      
      private function setTimer1() : void
      {
         clearTimeout(this.timer1);
         this.mainUI_mc["bigFire_mc"].visible = false;
         this.mainUI_mc["bigFire_mc"].gotoAndStop(1);
         this.mainUI_mc["yan_mc"].visible = false;
         this.mainUI_mc["yan_mc"]["yan"].gotoAndStop(1);
         NpcTipDialog.show("真不错！你还知道氢气是氧气的2倍量时能够爆出最大火焰。喷火装备拿好，快去克洛斯星上用它制服蘑菇怪兽。",this.taskComplete,this.dd,0,this.taskComplete);
      }
      
      private function taskComplete() : void
      {
         ItemAction.buyItem(100044,false);
         this.destroy();
      }
      
      private function stopPaoPao() : void
      {
         for(var j1:int = 0; j1 < 6; j1++)
         {
            this.mainUI_mc["pao" + (j1 + 1)].gotoAndStop(1);
            this.mainUI_mc["pao" + (j1 + 1)].visible = false;
         }
      }
      
      private function playPao(index1:uint, index2:uint) : void
      {
         for(var j1:int = int(index1); j1 < index2; j1++)
         {
            this.mainUI_mc["pao" + (j1 + 1)].play();
            this.mainUI_mc["pao" + (j1 + 1)].visible = true;
         }
      }
      
      private function onAddO2MouseOverHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["addO2_mc"].gotoAndStop(2);
         this.mainUI_mc["addO2_mc"].addEventListener(MouseEvent.MOUSE_DOWN,this.onAddO2MouseDownHandler);
         this.mainUI_mc["addO2_mc"].addEventListener(MouseEvent.MOUSE_OUT,this.onAddO2MouseOutHandler);
      }
      
      private function onAddO2MouseDownHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["addO2_mc"].gotoAndStop(3);
         this.mainUI_mc["addO2_mc"].addEventListener(MouseEvent.MOUSE_UP,this.onAddO2MouseUpHandler);
         this.mainUI_mc["addO2_mc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onAddO2MouseOutHandler);
         this.playPao(0,3);
         this.mainUI_mc["gu_mc"].play();
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
      }
      
      private function onAddO2MouseOutHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["addO2_mc"].gotoAndStop(1);
         this.mainUI_mc["addO2_mc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onAddO2MouseOutHandler);
         this.mainUI_mc["addO2_mc"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onAddO2MouseDownHandler);
         this.mainUI_mc["addO2_mc"].removeEventListener(MouseEvent.MOUSE_UP,this.onAddO2MouseUpHandler);
      }
      
      private function onAddO2MouseUpHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["addO2_mc"].gotoAndStop(1);
         this.stopPaoPao();
         this.mainUI_mc["gu_mc"].gotoAndStop(1);
         this.mainUI_mc["addO2_mc"].removeEventListener(MouseEvent.MOUSE_UP,this.onAddO2MouseUpHandler);
         this.mainUI_mc["addO2_mc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onAddO2MouseOutHandler);
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
      }
      
      private function onEnterFrameHandler(event:Event) : void
      {
         this.o2_num += this.addNum;
         this.mainUI_mc["bili_txt"].text = int(100 * this.o2_num / this.h2_num) + "%";
         this.setO2(this.o2_num.toFixed(2));
      }
      
      private function onAddH2MouseOverHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["addH2_mc"].gotoAndStop(2);
         this.mainUI_mc["addH2_mc"].addEventListener(MouseEvent.MOUSE_DOWN,this.onAddH2MouseDownHandler);
         this.mainUI_mc["addH2_mc"].addEventListener(MouseEvent.MOUSE_OUT,this.onAddH2MouseOutHandler);
      }
      
      private function onAddH2MouseUpHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["addH2_mc"].removeEventListener(MouseEvent.MOUSE_UP,this.onAddH2MouseUpHandler);
         this.mainUI_mc["addH2_mc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onAddH2MouseOutHandler);
         this.mainUI_mc["addH2_mc"].gotoAndStop(1);
         this.stopPaoPao();
         this.mainUI_mc["gu_mc"].gotoAndStop(1);
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1Handler);
      }
      
      private function onAddH2MouseDownHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["addH2_mc"].addEventListener(MouseEvent.MOUSE_UP,this.onAddH2MouseUpHandler);
         this.mainUI_mc["addH2_mc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onAddH2MouseOutHandler);
         this.mainUI_mc["addH2_mc"].gotoAndStop(3);
         this.playPao(3,6);
         this.mainUI_mc["gu_mc"].play();
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame1Handler);
      }
      
      private function onEnterFrame1Handler(event:Event) : void
      {
         this.h2_num += this.addNum;
         this.mainUI_mc["bili_txt"].text = int(100 * this.o2_num / this.h2_num) + "%";
         this.setH2(this.h2_num.toFixed(2));
      }
      
      private function onAddH2MouseOutHandler(event:MouseEvent) : void
      {
         this.mainUI_mc["addH2_mc"].removeEventListener(MouseEvent.MOUSE_UP,this.onAddH2MouseUpHandler);
         this.mainUI_mc["addH2_mc"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onAddH2MouseDownHandler);
         this.mainUI_mc["addH2_mc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onAddH2MouseOutHandler);
         this.mainUI_mc["addH2_mc"].gotoAndStop(1);
      }
      
      private function setO2(s1:String) : void
      {
         this.mainUI_mc["o2_txt"].text = s1;
      }
      
      private function setH2(s1:String) : void
      {
         this.mainUI_mc["h2_txt"].text = s1;
      }
   }
}

