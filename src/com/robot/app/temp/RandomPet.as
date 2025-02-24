package com.robot.app.temp
{
   import com.robot.core.mode.ActionSpriteModel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class RandomPet extends ActionSpriteModel
   {
      private static var oldStr:String;
      
      public static const RED:String = "red";
      
      public static const WHITE:String = "white";
      
      private var colors:Array = [RED,WHITE];
      
      private var mc:MovieClip;
      
      private var array:Array = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
      
      private var posArray:Array = [];
      
      public var type:String;
      
      public function RandomPet()
      {
         super();
         this.type = this.colors[Math.floor(Math.random() * this.colors.length)];
         this.loadUI();
         this.x = int(Math.random() * 524) + 235;
         this.y = int(Math.random() * 234) + 155;
      }
      
      public function get color() : String
      {
         return this.type;
      }
      
      private function loadUI() : void
      {
         ResourceManager.getResource("resource/pet/swf/npc.swf",function(o:DisplayObject):void
         {
            var t:ColorTransform = null;
            var mc:MovieClip = o as MovieClip;
            if(type == RED)
            {
               t = new ColorTransform();
               t.color = 16711680;
               mc.transform.colorTransform = t;
            }
            addChild(mc);
            mc.gotoAndStop(array[Math.floor(Math.random() * array.length)]);
         },"pet");
      }
      
      override public function destroy() : void
      {
         super.destroy();
         DisplayUtil.removeForParent(this);
         this.mc = null;
      }
   }
}

