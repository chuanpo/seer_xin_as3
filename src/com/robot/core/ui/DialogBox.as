package com.robot.core.ui
{
   import com.robot.core.config.xml.EmotionXMLInfo;
   import com.robot.core.manager.UIManager;
   import com.robot.core.npc.ParseDialogStr;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import org.taomee.component.containers.Box;
   import org.taomee.component.control.MLabel;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.component.layout.FlowWarpLayout;
   import org.taomee.utils.DisplayUtil;
   
   public class DialogBox extends Sprite
   {
      private var boxMC:MovieClip;
      
      private var bgMC:MovieClip;
      
      private var arrowMC:MovieClip;
      
      private var txt:TextField;
      
      private var timer:Timer;
      
      private var txtBox:Box;
      
      private var instance:DialogBox;
      
      public function DialogBox()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
         this.boxMC = UIManager.getMovieClip("word_box");
         this.bgMC = this.boxMC["bg_mc"];
         this.arrowMC = this.boxMC["arrow_mc"];
         this.txt = this.boxMC["txt"];
         this.txt.autoSize = TextFieldAutoSize.LEFT;
         this.timer = new Timer(4000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.closeBox);
         this.instance = this;
         this.txtBox = new Box();
         this.txtBox.isMask = false;
         this.txtBox.width = 140;
         this.txtBox.layout = new FlowWarpLayout(FlowWarpLayout.LEFT,FlowWarpLayout.BOTTOM,-5,-3);
      }
      
      public function show(str:String, x:Number = 0, y:Number = 0, owner:DisplayObjectContainer = null) : void
      {
         var mc:MovieClip = null;
         if(str.indexOf("#") != -1)
         {
            this.showNewEmotion(str,x,y,owner);
            return;
         }
         if(str.substr(0,1) == "$")
         {
            mc = UIManager.getMovieClip("e" + str.substring(1,str.length));
            if(Boolean(mc))
            {
               mc.scaleY = 1.5;
               mc.scaleX = 1.5;
               mc.x = this.bgMC.x + this.bgMC.width / 2;
               mc.y = -38;
               this.boxMC.addChild(mc);
               this.txt.text = "\n\n\n";
            }
            else
            {
               this.txt.text = str;
            }
         }
         else
         {
            this.txt.text = str;
         }
         if(this.txt.textWidth > 70)
         {
            this.bgMC.width = this.txt.textWidth + 14;
            this.bgMC.x = -this.bgMC.width / 2;
         }
         this.bgMC.height = this.txt.textHeight + 8;
         this.bgMC.y = -this.bgMC.height - this.arrowMC.height + 4;
         this.txt.x = this.bgMC.x + 5;
         this.txt.y = this.bgMC.y + 2;
         this.addChild(this.boxMC);
         this.x = x;
         this.y = y;
         if(Boolean(owner))
         {
            owner.addChild(this);
         }
         this.txt.x = this.bgMC.x + (this.bgMC.width - this.txt.textWidth) / 2 - 2;
         this.autoClose();
      }
      
      public function setArrow(prop:String, value:*) : void
      {
         this.arrowMC[prop] = value;
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      public function destroy() : void
      {
         if(Boolean(this.txtBox))
         {
            this.txtBox.removeAll();
            this.txtBox.destroy();
            this.txtBox = null;
         }
         DisplayUtil.removeForParent(this);
         this.boxMC = null;
         this.bgMC = null;
         this.arrowMC = null;
         this.txt = null;
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.closeBox);
            this.timer = null;
         }
      }
      
      public function getBoxMC() : MovieClip
      {
         return this.boxMC;
      }
      
      private function autoClose() : void
      {
         this.timer.start();
      }
      
      private function closeBox(event:TimerEvent) : void
      {
         this.destroy();
      }
      
      private function showNewEmotion(str:String, x:Number = 0, y:Number = 0, owner:DisplayObjectContainer = null) : void
      {
         var i:String = null;
         var add:Function = null;
         var j:uint = 0;
         var s:String = null;
         var lable:MLabel = null;
         var c:uint = 0;
         var loadPanel:MLoadPane = null;
         add = function():void
         {
            bgMC.width = txtBox.getContainSprite().width + 14;
            bgMC.x = -bgMC.width / 2;
            bgMC.height = txtBox.getContainSprite().height + 8;
            bgMC.y = -bgMC.height - arrowMC.height + 4;
            txtBox.x = bgMC.x + 5;
            txtBox.y = bgMC.y + 2;
            boxMC.addChild(txtBox);
            addChild(boxMC);
            instance.x = x;
            instance.y = y;
            if(Boolean(owner))
            {
               owner.addChild(instance);
            }
            autoClose();
         };
         var parse:ParseDialogStr = new ParseDialogStr(str);
         var count:uint = 0;
         for each(i in parse.strArray)
         {
            for(j = 0; j < i.length; j++)
            {
               s = i.charAt(j);
               lable = new MLabel(s);
               lable.fontSize = 12;
               c = uint("0x" + parse.getColor(count));
               if(c == 16777215)
               {
                  c = 0;
               }
               lable.textColor = c;
               lable.cacheAsBitmap = true;
               this.txtBox.append(lable);
            }
            count++;
            if(parse.getEmotionNum(count) != -1)
            {
               loadPanel = new MLoadPane(EmotionXMLInfo.getURL("#" + parse.getEmotionNum(count)),MLoadPane.FIT_NONE,MLoadPane.MIDDLE,MLoadPane.MIDDLE);
               loadPanel.setSizeWH(45,40);
               this.txtBox.append(loadPanel);
            }
         }
         setTimeout(add,300);
      }
   }
}

