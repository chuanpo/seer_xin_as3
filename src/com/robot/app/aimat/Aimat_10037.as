package com.robot.app.aimat
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.GeomUtil;
   
   public class Aimat_10037 extends BaseAimat
   {
      private var speedPos:Point;
      
      private var ui:MovieClip;
      
      private var ui2:MovieClip;
      
      private var _speed:Number = 20;
      
      private var timen:uint = 0;
      
      private var _sound:Sound;
      
      private var _soundc:SoundChannel;
      
      public function Aimat_10037()
      {
         super();
      }
      
      override public function execute(info:AimatInfo) : void
      {
         super.execute(info);
         if(info.speed > 0)
         {
            this._speed = info.speed;
         }
         this.ui = AimatController.getResEffect(_info.id);
         this.ui.x = _info.startPos.x;
         this.ui.y = _info.startPos.y;
         this.ui.mouseEnabled = false;
         this.ui.mouseChildren = false;
         this.ui.rotation = GeomUtil.pointAngle(_info.endPos,_info.startPos);
         MapManager.currentMap.depthLevel.addChild(this.ui);
         this.speedPos = GeomUtil.angleSpeed(_info.endPos,_info.startPos);
         this.speedPos.x *= this._speed;
         this.speedPos.y *= this._speed;
         this.ui.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this.ui))
         {
            this.ui.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            DisplayUtil.removeForParent(this.ui);
            this.ui = null;
         }
         this.speedPos = null;
         if(Boolean(this.ui2))
         {
            this.onEnd();
         }
      }
      
      private function enterFranepao(e:Event) : void
      {
         var temp:MovieClip = e.target as MovieClip;
         if(temp.currentFrame == temp.totalFrames - 1)
         {
            temp.removeEventListener(Event.ENTER_FRAME,this.enterFranepao);
            MapManager.currentMap.depthLevel.removeChild(temp);
         }
      }
      
      private function onEnter(e:Event) : void
      {
         var paoui:MovieClip = null;
         var list:Array = null;
         var obj:DisplayObject = null;
         ++this.timen;
         if(this.timen == 2)
         {
            paoui = AimatController.getResEffect(_info.id,"_0");
            paoui.x = this.ui.x;
            paoui.y = this.ui.y;
            MapManager.currentMap.depthLevel.addChild(paoui);
            paoui.addEventListener(Event.ENTER_FRAME,this.enterFranepao);
            this.timen = 0;
         }
         if(Math.abs(this.ui.x - _info.endPos.x) < this._speed / 2 && Math.abs(this.ui.y - _info.endPos.y) < this._speed / 2)
         {
            this.ui.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
            DisplayUtil.removeForParent(this.ui);
            this.ui = null;
            this._sound = AimatController.getResSound(_info.id);
            this._soundc = this._sound.play(0,1);
            this.ui2 = AimatController.getResState(_info.id);
            this.ui2.x = _info.endPos.x;
            this.ui2.y = _info.endPos.y;
            this.ui2.mouseEnabled = false;
            this.ui2.mouseChildren = false;
            this.ui2.addFrameScript(this.ui2.totalFrames - 1,this.onEnd);
            MapManager.currentMap.depthLevel.addChild(this.ui2);
            list = MapManager.getObjectsPointRect(_info.endPos,30,[IAimatSprite]);
            for each(obj in list)
            {
               if(obj is IAimatSprite)
               {
                  IAimatSprite(obj).aimatState(_info);
               }
            }
            return;
         }
         this.ui.x += this.speedPos.x;
         this.ui.y += this.speedPos.y;
      }
      
      private function onEnd() : void
      {
         this._soundc.stop();
         this._sound = null;
         this._soundc = null;
         this.ui2.addFrameScript(this.ui2.totalFrames - 1,null);
         DisplayUtil.removeForParent(this.ui2);
         this.ui2 = null;
      }
   }
}

