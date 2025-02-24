package com.robot.core.aimat
{
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.ISprite;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.utils.Direction;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.utils.setTimeout;
   import gs.TweenMax;
   import gs.easing.Quad;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.GeomUtil;
   
   public class ThrowPropsController
   {
      private var mc:MovieClip;
      
      private var _isFullScreen:Boolean = false;
      
      private var _itemID:uint;
      
      private var _userID:uint;
      
      private var _startPoint:Point;
      
      private var _endPoint:Point;
      
      public function ThrowPropsController(itemID:uint, userID:uint, obj:ISprite, endPos:Point)
      {
         var startPos:Point = null;
         var oy:int = 0;
         var ox:int = 0;
         super();
         if(itemID == 600002)
         {
            this._isFullScreen = true;
         }
         this._itemID = itemID;
         this._userID = userID;
         this._endPoint = endPos;
         this.mc = TaskIconManager.getIcon("item_" + itemID.toString()) as MovieClip;
         this.mc.gotoAndStop(1);
         startPos = obj.pos.clone();
         this._startPoint = startPos;
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
         var info:AimatInfo = new AimatInfo(itemID,userID,startPos,endPos);
         AimatController.dispatchEvent(AimatEvent.PLAY_START,info);
         TweenMax.to(this.mc,1,{
            "bezier":[{
               "x":ox,
               "y":oy
            },{
               "x":endPos.x,
               "y":endPos.y
            }],
            "onComplete":this.onThrowComp,
            "orientToBezier":true,
            "ease":Quad.easeIn
         });
      }
      
      private function onThrowComp() : void
      {
         var url:String;
         var mcloader:MCLoader = null;
         var info:AimatInfo = new AimatInfo(this._itemID,this._userID,this._startPoint,this._endPoint);
         AimatController.dispatchEvent(AimatEvent.PLAY_END,info);
         this.mc.gotoAndPlay(2);
         url = "resource/item/throw/animate/" + this._itemID + ".swf";
         mcloader = new MCLoader(url,LevelManager.mapLevel,-1);
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoaded);
         setTimeout(function():void
         {
            if(Boolean(mc))
            {
               DisplayUtil.removeForParent(mc);
               mc = null;
            }
            mcloader.doLoad();
         },1000);
      }
      
      private function onLoaded(evt:MCLoadEvent) : void
      {
         var app:ApplicationDomain;
         var cls:*;
         var r:uint;
         var throwMC:MovieClip = null;
         (evt.currentTarget as MCLoader).removeEventListener(MCLoadEvent.SUCCESS,this.onLoaded);
         app = evt.getApplicationDomain();
         cls = app.getDefinition("ThrowPropMC");
         throwMC = new cls() as MovieClip;
         r = Math.floor(Math.random() * throwMC.totalFrames) + 1;
         throwMC.gotoAndStop(r);
         if(this._isFullScreen)
         {
            throwMC.x = MainManager.getStage().width / 2;
            throwMC.y = MainManager.getStage().height / 2;
         }
         else
         {
            throwMC.x = this._endPoint.x;
            throwMC.y = this._endPoint.y;
         }
         LevelManager.mapLevel.addChild(throwMC);
         setTimeout(function():void
         {
            if(Boolean(throwMC))
            {
               DisplayUtil.removeForParent(throwMC);
               throwMC = null;
            }
         },10000);
      }
   }
}

