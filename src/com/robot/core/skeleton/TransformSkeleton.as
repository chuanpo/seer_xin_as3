package com.robot.core.skeleton
{
   import com.robot.core.CommandID;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.SuitXMLInfo;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.ISkeletonSprite;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.utils.Direction;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.media.Sound;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TransformSkeleton implements ISkeleton
   {
      private var _people:ISkeletonSprite;
      
      private var box:Sprite;
      
      private var _info:UserInfo;
      
      private var skeletonMC:MovieClip;
      
      private var movie:MovieClip;
      
      private var sound:Sound;
      
      public function TransformSkeleton()
      {
         super();
         this.box = new Sprite();
         this.box.buttonMode = true;
         this.box.mouseChildren = false;
         this.box.mouseEnabled = false;
      }
      
      public function set people(i:ISkeletonSprite) : void
      {
         this._people = i;
         this._people.direction = Direction.DOWN;
         this._people.sprite.addChild(this.box);
      }
      
      public function get people() : ISkeletonSprite
      {
         return this._people;
      }
      
      public function getSkeletonMC() : MovieClip
      {
         return this.skeletonMC;
      }
      
      public function destroy() : void
      {
         this.sound = null;
         DisplayUtil.removeForParent(this.movie);
         DisplayUtil.removeForParent(this.skeletonMC);
         this._people = null;
         this.movie = null;
         this.skeletonMC = null;
         this.box = null;
      }
      
      public function getBodyMC() : MovieClip
      {
         return this.skeletonMC;
      }
      
      public function set info(info:UserInfo) : void
      {
         this._info = info;
         var id:uint = info.changeShape;
         ResourceManager.getResourceList(ClientConfig.getTransformMovieUrl(info.changeShape),this.onLoadMovie,["item","sound"]);
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_START));
      }
      
      public function play() : void
      {
         if(Boolean(this.skeletonMC))
         {
            this.skeletonMC.addEventListener(Event.ENTER_FRAME,function(event:Event):void
            {
               var mc:MovieClip = skeletonMC.getChildAt(0) as MovieClip;
               if(Boolean(mc))
               {
                  skeletonMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  mc.gotoAndPlay(2);
               }
            });
         }
      }
      
      public function stop() : void
      {
         if(Boolean(this.skeletonMC))
         {
            this.skeletonMC.addEventListener(Event.ENTER_FRAME,function(event:Event):void
            {
               var mc:MovieClip = skeletonMC.getChildAt(0) as MovieClip;
               if(Boolean(mc))
               {
                  skeletonMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  mc.gotoAndPlay(1);
               }
            });
         }
      }
      
      public function changeDirection(dir:String) : void
      {
         if(Boolean(this.skeletonMC))
         {
            this.skeletonMC.gotoAndStop(dir);
         }
      }
      
      public function changeCloth(clothArray:Array) : void
      {
      }
      
      public function takeOffCloth() : void
      {
      }
      
      public function changeColor(color:uint, isTexture:Boolean = true) : void
      {
      }
      
      public function changeDoodle(url:String) : void
      {
      }
      
      public function specialAction(peopleMode:BasePeoleModel, id:int) : void
      {
      }
      
      public function untransform() : void
      {
         var mc:MovieClip = null;
         if(Boolean(this.sound))
         {
            this.sound.play(0,1);
         }
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_START));
         this._people.direction = Direction.DOWN;
         DisplayUtil.removeForParent(this.skeletonMC);
         if(Boolean(this.movie))
         {
            this._people.sprite.addChild(this.movie);
            mc = this.movie["mc"];
            mc.addEventListener(Event.ENTER_FRAME,function():void
            {
               if(mc.currentFrame > 1)
               {
                  mc.prevFrame();
               }
               else
               {
                  mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  if(_people == MainManager.actorModel)
                  {
                     SocketConnection.send(CommandID.PEOPLE_TRANSFROM,0);
                     EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_OVER));
                  }
                  (_people as BasePeoleModel).skeleton = new EmptySkeletonStrategy();
                  AimatController.setClothType(MainManager.actorInfo.clothIDs);
               }
            });
         }
         else
         {
            if(this._people == MainManager.actorModel)
            {
               SocketConnection.send(CommandID.PEOPLE_TRANSFROM,0);
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_OVER));
            }
            (this._people as BasePeoleModel).skeleton = new EmptySkeletonStrategy();
            AimatController.setClothType(MainManager.actorInfo.clothIDs);
         }
      }
      
      private function onLoadMovie(array:Array) : void
      {
         this.movie = array[0] as MovieClip;
         this.sound = array[1] as Sound;
         this.loadSWF();
      }
      
      private function loadSWF() : void
      {
         ResourceManager.getResource(ClientConfig.getTransformClothUrl(this._info.changeShape),this.onLoadSWF);
      }
      
      private function onLoadSWF(o:DisplayObject) : void
      {
         this.skeletonMC = o as MovieClip;
         this.transform();
      }
      
      private function transform() : void
      {
         var mc:MovieClip = null;
         AimatController.setClothType(MainManager.actorInfo.clothIDs);
         if(Boolean(this.sound))
         {
            this.sound.play(0,1);
         }
         this._people.clearOldSkeleton();
         this.people.sprite.addChild(this.movie);
         mc = this.movie["mc"];
         mc.gotoAndPlay(2);
         mc.addEventListener(Event.ENTER_FRAME,function():void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               stop();
               mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               DisplayUtil.removeForParent(movie);
               box.addChild(skeletonMC);
               (_people as BasePeoleModel).speed = SuitXMLInfo.getSuitTranSpeed(_info.changeShape);
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.TRANSFORM_OVER));
            }
         });
      }
   }
}

