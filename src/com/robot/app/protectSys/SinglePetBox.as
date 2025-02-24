package com.robot.app.protectSys
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.utils.Direction;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.manager.ResourceManager;
   
   public class SinglePetBox extends MLoadPane
   {
      public static const UP:uint = 0;
      
      public static const DOWN:uint = 1;
      
      public static const LEFT:uint = 2;
      
      private var mc:MovieClip;
      
      private var type:uint;
      
      public function SinglePetBox(id:uint, type:uint = 0)
      {
         super(null,MLoadPane.FIT_HEIGHT);
         this.isMask = false;
         setSizeWH(90,80);
         this.type = type;
         ResourceManager.getResource(ClientConfig.getPetSwfPath(id),this.onLoad,"pet");
      }
      
      public function get dirType() : uint
      {
         return this.type;
      }
      
      private function onLoad(o:DisplayObject) : void
      {
         this.mc = o as MovieClip;
         if(Boolean(this.mc))
         {
            this.setIcon(this.mc);
            this.mc.addEventListener(Event.ENTER_FRAME,function(e:Event):void
            {
               var s:MovieClip = mc.getChildAt(0) as MovieClip;
               if(Boolean(s))
               {
                  mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  s.gotoAndStop(1);
               }
            });
            if(this.type == UP)
            {
               this.mc.gotoAndStop(Direction.UP);
            }
            else if(this.type == DOWN)
            {
               this.mc.gotoAndStop(Direction.DOWN);
            }
            else if(this.type == LEFT)
            {
               this.mc.gotoAndStop(Direction.LEFT);
            }
         }
      }
   }
}

