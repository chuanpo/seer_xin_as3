package com.robot.core.mode
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.pet.PetInfoController;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MovieClipUtil;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.UIManager;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import com.robot.core.config.xml.ShinyXMLInfo;
   
   public class PetModel extends ActionSpriteModel
   {
      public static const MAX:int = 40;
      
      private var _people:ActionSpriteModel;
      
      private var _petMc:MovieClip;
      
      private var _info:PetShowInfo;

      private var _petLight:MovieClip;

      protected var filte:GlowFilter = new GlowFilter(3355443,0.9,3,3,3.1);
      
      public function PetModel(people:ActionSpriteModel)
      {
         super();
         _speed = 3;
         this._people = people;
         buttonMode = true;
      }
      
      public function get info() : PetShowInfo
      {
         return this._info;
      }
      
      override public function set direction(dir:String) : void
      {
         if(dir == null || dir == "")
         {
            return;
         }
         if(Boolean(this._petMc))
         {
            this._petMc.gotoAndStop(dir);
         }
      }
      
      override public function get centerPoint() : Point
      {
         _centerPoint.x = x;
         _centerPoint.y = y - 10;
         return _centerPoint;
      }
      
      override public function get hitRect() : Rectangle
      {
         _hitRect.x = x - width / 2;
         _hitRect.y = y - height;
         _hitRect.width = width;
         _hitRect.height = height;
         return _hitRect;
      }
      
      public function show(info:PetShowInfo) : void
      {
         this._info = info;
         x = this._people.x + 40;
         y = this._people.y + 5;
         MapManager.currentMap.depthLevel.addChild(this);
         this.addEvent();
         if(Boolean(this._petMc))
         {
            this.bright();
            if(info.userID != MainManager.actorID && UserManager._hideOtherUserModelFlag) this.visible = false;
            return;
         }
         ResourceManager.getResource(ClientConfig.getPetSwfPath(this._info.skinID != 0 ? this._info.skinID : this._info.petID),this.onLoad,"pet");
         if(info.userID != MainManager.actorID && UserManager._hideOtherUserModelFlag) this.visible = false;
      }
      
      public function hide() : void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this);
      }
      
      public function bright() : void
      {
         this.removeBright();
         if(this._info.dv == 31 && Boolean(this._petMc))
         {
            this._petLight = UIManager.getMovieClip("PetBright_MC");
            this._petMc.addChildAt(this._petLight,0);
         }
      }
      
      public function removeBright() : void
      {
         if(this._petLight)
         {
            DisplayUtil.removeForParent(this._petLight);
            this._petLight = null;
         }
      }
      

      public function walkAction(data:Object) : void
      {
         if(this._people == null)
         {
            return;
         }
         _walk.execute(this,data,false);
      }
      
      override public function destroy() : void
      {
         ResourceManager.cancel(ClientConfig.getPetSwfPath(this._info.skinID != 0 ? this._info.skinID : this._info.petID),this.onLoad);
         super.destroy();
         this.hide();
         this._people = null;
         if(Boolean(this._petMc))
         {
            this._petMc = null;
         }
      }
      
      private function onLoad(obj:DisplayObject) : void
      {
         if(this._people == null)
         {
            return;
         }
         this._petMc = obj as MovieClip;
         MovieClipUtil.childStop(this._petMc,1);
         this.direction = this._people.direction;
         addChild(this._petMc);
         if(this._info.shiny != 0)
         {
            var matrix:ColorMatrixFilter = null;
            var argArray:Array = ShinyXMLInfo.getShinyArray(this._info.petID);
            matrix = new ColorMatrixFilter(argArray);
            var glow:GlowFilter = null;
            var glowArray:Array = ShinyXMLInfo.getGlowArray(this._info.petID);
            glow = new GlowFilter(uint(glowArray[0]),int(glowArray[1]),int(glowArray[2]),int(glowArray[3]),int(glowArray[4]));
            this._petMc.filters = [ filte,glow,matrix ]
         }
         this.bright();
         if(_walk.isPlaying)
         {
            this.onWalkStart(null);
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         addEventListener(RobotEvent.WALK_END,this.onWalkOver);
         addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnterFrame);
         this._people.addEventListener(RobotEvent.WALK_START,this.onPeopleWalkStart);
         if(this._people.walk.isPlaying)
         {
            this._people.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
         }
         addEventListener(MouseEvent.CLICK,this.onPetClickHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         removeEventListener(RobotEvent.WALK_END,this.onWalkOver);
         removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnterFrame);
         this._people.removeEventListener(RobotEvent.WALK_START,this.onPeopleWalkStart);
         this._people.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
         removeEventListener(MouseEvent.CLICK,this.onPetClickHandler);
      }
      
      private function onWalkStart(e:Event) : void
      {
         var mc:MovieClip = null;
         if(Boolean(this._petMc))
         {
            mc = this._petMc.getChildAt(0) as MovieClip;
            if(Boolean(mc))
            {
               if(mc.currentFrame == 1)
               {
                  mc.gotoAndPlay(2);
               }
            }
         }
      }
      
      private function onWalkEnterFrame(e:Event) : void
      {
         if(Point.distance(pos,_walk.endP) < MAX)
         {
            stop();
         }
      }
      
      private function onWalkOver(e:Event) : void
      {
         if(Boolean(this._petMc))
         {
            MovieClipUtil.childStop(this._petMc,1);
         }
      }
      
      private function onPetClickHandler(e:MouseEvent) : void
      {
         PetInfoController.getInfo(false,this._info.userID,this._info.catchTime);
      }
      
      private function onPeopleWalkStart(e:Event) : void
      {
         this._people.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
      }
      
      private function onPeopleWalkEnter(e:Event) : void
      {
         var data:Array = null;
         if(Boolean(this._petMc))
         {
            if(Point.distance(pos,this._people.pos) > MAX)
            {
               if(Point.distance(pos,this._people.walk.endP) > Point.distance(this._people.pos,this._people.walk.endP))
               {
                  data = this._people.walk.remData;
                  data.unshift(this._people.pos);
                  data.unshift(pos);
                  this.walkAction(data);
                  this._people.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
               }
            }
         }
      }
   }
}

