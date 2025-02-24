package com.robot.app.toolBar.pkTool
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.xml.ShotDisXMLInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class ShotMouseIcon extends BasePKMouseIcon implements IPKMouseIcon
   {
      private var bmp:Bitmap;
      
      public function ShotMouseIcon()
      {
         super();
         ToolTipManager.add(this,"射击");
      }
      
      override protected function getIcon() : Sprite
      {
         var sprite:Sprite = new Sprite();
         sprite.addChild(ShotBehaviorManager.getMovieClip("pk_icon_bg"));
         var btn:SimpleButton = ShotBehaviorManager.getButton("pk_icon_shot");
         DisplayUtil.align(btn,sprite.getRect(sprite),AlignType.MIDDLE_CENTER);
         sprite.addChild(btn);
         return sprite;
      }
      
      override protected function getMouseIcon() : Sprite
      {
         var sprite:Sprite = new Sprite();
         var mouseMC:MovieClip = ShotBehaviorManager.getMovieClip("pk_mouseIcon_shot");
         this.bmp = DisplayUtil.copyDisplayAsBmp(mouseMC);
         sprite.graphics.beginFill(0,0);
         sprite.graphics.drawRect(this.bmp.x,this.bmp.y,this.bmp.width,this.bmp.height);
         sprite.addChild(this.bmp);
         return sprite;
      }
      
      override public function move(p:Point) : void
      {
         var myP:Point = MainManager.actorModel.localToGlobal(new Point());
         if(Point.distance(myP,p) > shotDis)
         {
            outOfDistance = true;
            this.bmp.visible = false;
            mouseIcon.addChild(forbidIcon);
         }
         else
         {
            outOfDistance = false;
            this.bmp.visible = true;
            DisplayUtil.removeForParent(forbidIcon);
         }
      }
      
      override public function click() : void
      {
         AimatController.setClothType(MainManager.actorInfo.clothIDs);
         MainManager.actorModel.aimatAction(0,AimatController.type,new Point(LevelManager.mapLevel.mouseX,LevelManager.mapLevel.mouseY));
      }
      
      override public function show() : void
      {
         super.show();
         var dis:uint = uint(ShotDisXMLInfo.getClothDistance(MainManager.actorInfo.clothIDs));
         MainManager.actorModel.showShotRadius(dis);
      }
   }
}

