package com.robot.core.aimat
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.ISprite;
   import com.robot.core.utils.Direction;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import gs.TweenLite;
   import gs.TweenMax;
   import gs.easing.Quad;
   import org.taomee.utils.GeomUtil;
   
   public class ThrowController
   {
      private var array:Array;
      
      private var mc:MovieClip;
      
      public function ThrowController(itemID:uint, userID:uint, obj:ISprite, endPos:Point)
      {
         var oy:int = 0;
         var ox:int = 0;
         this.array = [65280,1046943,39167,16776960,6632191,16777215];
         super();
         this.mc = UIManager.getMovieClip("ui_Beacon");
         this.mc.gotoAndStop(1);
         var startPos:Point = obj.pos.clone();
         startPos.y -= 40;
         obj.direction = Direction.angleToStr(GeomUtil.pointAngle(startPos,endPos));
         var mode:BasePeoleModel = obj as BasePeoleModel;
         if(mode.direction == Direction.RIGHT_UP || mode.direction == Direction.LEFT_UP)
         {
            oy = endPos.y - Math.abs(endPos.x - startPos.y) / 2;
         }
         else
         {
            oy = startPos.y - Math.abs(endPos.x - startPos.y) / 2;
         }
         ox = startPos.x + (endPos.x - startPos.x) / 2;
         this.mc.x = startPos.x;
         this.mc.y = startPos.y;
         LevelManager.mapLevel.addChild(this.mc);
         TweenMax.to(this.mc,1.5,{
            "bezier":[{
               "x":ox,
               "y":oy
            },{
               "x":endPos.x,
               "y":endPos.y
            }],
            "onComplete":this.onComp,
            "orientToBezier":true,
            "ease":Quad.easeOut
         });
      }
      
      private function onComp() : void
      {
         this.mc.rotation = 0;
         TweenLite.to(this.mc,2,{
            "scaleX":2,
            "scaleY":2
         });
         this.mc.gotoAndPlay(2);
         var t:ColorTransform = new ColorTransform();
         t.color = this.array[Math.floor(Math.random() * this.array.length)];
         this.mc.transform.colorTransform = t;
      }
   }
}

