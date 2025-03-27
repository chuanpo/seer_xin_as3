package com.robot.app.protectSys
{
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.manager.UIManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.containers.VBox;
   import org.taomee.component.control.MText;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class KillPluginPanel extends Sprite
   {
      public static const WRONG:String = "wrong";
      
      public static const RIGHT:String = "right";
      
      private var bg:Sprite;
      
      private var mainBox:VBox;
      
      private var petBox:HBox;
      
      private var DIR_TYPE:uint;
      
      private var STR_LIST:Array = ["背面","正面","侧面"];
      
      public function KillPluginPanel()
      {
         super();
         this.petBox = new HBox(15);
         this.petBox.halign = FlowLayout.CENTER;
         this.petBox.valign = FlowLayout.MIDLLE;
         this.petBox.setSizeWH(410,130);
         this.bg = UIManager.getSprite("Panel_Background");
         this.bg.width = 475;
         this.bg.height = 292;
         addChild(this.bg);
         var white:Sprite = UIManager.getSprite("Panel_Background_5");
         white.width = 424;
         white.height = 240;
         DisplayUtil.align(white,this.getRect(this),AlignType.MIDDLE_CENTER);
         addChild(white);
         this.mainBox = new VBox();
         this.mainBox.halign = FlowLayout.CENTER;
         this.mainBox.valign = FlowLayout.MIDLLE;
         this.mainBox.setSizeWH(410,225);
         DisplayUtil.align(this.mainBox,this.getRect(this),AlignType.MIDDLE_CENTER);
         addChild(this.mainBox);
         this.mainBox.append(this.petBox);
         this.DIR_TYPE = Math.floor(Math.random() * 3);
         var txt:MText = new MText();
         txt.align = TextFormatAlign.CENTER;
         txt.setSizeWH(410,30);
         txt.text = "请选择<b><font color=\'#0000ff\'>" + this.STR_LIST[this.DIR_TYPE] + "</font><font color=\'#ff0000\'>朝向你</font></b>的精灵！";
         this.mainBox.append(txt);
         this.getPet();
      }
      
      private function getPet() : void
      {
         var petIDIndex:uint = 0;
         var singlePet:SinglePetBox = null;
         var index:uint = 0;
         var num:uint = Math.floor(Math.random() * 4);
         for(var i:uint = 0; i < 4; i++)
         {
            petIDIndex = Math.floor(Math.random() * 500);
            if(i == num)
            {
               singlePet = new SinglePetBox(PetXMLInfo.getIdList()[petIDIndex],this.DIR_TYPE);
            }
            else
            {
               if(this.DIR_TYPE == SinglePetBox.DOWN)
               {
                  index = SinglePetBox.UP;
               }
               else if(this.DIR_TYPE == SinglePetBox.LEFT)
               {
                  index = SinglePetBox.UP;
               }
               else if(this.DIR_TYPE == SinglePetBox.UP)
               {
                  index = SinglePetBox.DOWN;
               }
               singlePet = new SinglePetBox(PetXMLInfo.getIdList()[petIDIndex],index);
            }
            singlePet.buttonMode = true;
            singlePet.mouseChildren = true;
            singlePet.addEventListener(MouseEvent.CLICK,this.clickSinglePet);
            this.petBox.append(singlePet);
         }
      }
      
      private function clickSinglePet(event:MouseEvent) : void
      {
         var target:SinglePetBox = event.currentTarget as SinglePetBox;
         if(target.dirType == this.DIR_TYPE)
         {
            trace("--------------------- kill plugin ---------------------------");
            trace("select right");
            trace("--------------------- end kill plugin ---------------------------");
            dispatchEvent(new Event(RIGHT));
         }
         else
         {
            trace("--------------------- kill plugin ---------------------------");
            trace("select wrong");
            trace("--------------------- end kill plugin ---------------------------");
            dispatchEvent(new Event(WRONG));
         }
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this);
         this.mainBox.destroy();
         this.mainBox = null;
         this.petBox = null;
      }
   }
}

