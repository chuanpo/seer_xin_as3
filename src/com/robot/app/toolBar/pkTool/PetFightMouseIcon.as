package com.robot.app.toolBar.pkTool
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.teamPK.TeamPKManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.effect.ColorFilter;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PetFightMouseIcon extends BasePKMouseIcon implements IPKMouseIcon
   {
      private var bmp:Bitmap;
      
      public function PetFightMouseIcon()
      {
         super();
         ToolTipManager.add(this,"精灵对战");
      }
      
      override protected function getIcon() : Sprite
      {
         var sprite:Sprite = new Sprite();
         sprite.addChild(ShotBehaviorManager.getMovieClip("pk_icon_bg"));
         var btn:SimpleButton = ShotBehaviorManager.getButton("pk_icon_fight");
         DisplayUtil.align(btn,sprite.getRect(sprite),AlignType.MIDDLE_CENTER);
         sprite.addChild(btn);
         return sprite;
      }
      
      override protected function getMouseIcon() : Sprite
      {
         var sprite:Sprite = new Sprite();
         var mouseMC:MovieClip = ShotBehaviorManager.getMovieClip("pk_mouseIcon_pet");
         this.bmp = DisplayUtil.copyDisplayAsBmp(mouseMC);
         sprite.graphics.beginFill(0,0);
         sprite.graphics.drawRect(this.bmp.x,this.bmp.y,this.bmp.width,this.bmp.height);
         sprite.addChild(this.bmp);
         return sprite;
      }
      
      override public function move(p:Point) : void
      {
         var myP:Point = MainManager.actorModel.localToGlobal(new Point());
         if(Point.distance(myP,p) > petDis)
         {
            outOfDistance = true;
            mouseIcon.filters = [ColorFilter.setGrayscale()];
         }
         else
         {
            outOfDistance = false;
            mouseIcon.filters = [];
         }
      }
      
      override public function click() : void
      {
         var i:BasePeoleModel = null;
         for each(i in UserManager.getUserModelList())
         {
            if(i.hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY))
            {
               if(i.isShield)
               {
                  i.showShieldMovie();
               }
               else
               {
                  TeamPKManager.petFight(i.info.userID);
               }
               break;
            }
         }
      }
      
      override public function show() : void
      {
         super.show();
         MainManager.actorModel.showShotRadius(petDis);
      }
   }
}

