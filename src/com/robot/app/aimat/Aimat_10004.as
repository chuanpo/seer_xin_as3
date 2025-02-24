package com.robot.app.aimat
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.GeomUtil;
   
   public class Aimat_10004 extends BaseAimat
   {
      private var speedPos:Point;
      
      private var ui:MovieClip;
      
      private var ui2:MovieClip;
      
      private var arr:Array = [];
      
      private var _speed:Number = 20;
      
      public function Aimat_10004()
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
         this.ui.y = _info.startPos.y - this.ui.height - 6;
         this.ui.mouseEnabled = false;
         this.ui.mouseChildren = false;
         this.ui.scaleX = _info.endPos.x > _info.startPos.x ? 1 : -1;
         MapManager.currentMap.depthLevel.addChild(this.ui);
         _info.startPos.x = this.ui.scaleX > 0 ? this.ui.x + this.ui.width + this._speed : this.ui.x - this.ui.width - this._speed;
         _info.startPos.y = this.ui.y;
         this.speedPos = GeomUtil.angleSpeed(_info.endPos,_info.startPos);
         this.speedPos.x *= this._speed;
         this.speedPos.y *= this._speed;
         this.ui.addFrameScript(this.ui.totalFrames - 1,this.onEnd);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this.ui))
         {
            this.ui.addFrameScript(this.ui.totalFrames - 1,null);
            DisplayUtil.removeForParent(this.ui);
            this.ui = null;
         }
         this.speedPos = null;
         if(Boolean(this.ui2))
         {
            this.ui2.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            DisplayUtil.removeForParent(this.ui2);
            this.ui2 = null;
         }
         this.arr = null;
      }
      
      private function onEnd() : void
      {
         var pp:MovieClip = null;
         this.ui.addFrameScript(this.ui.totalFrames - 1,null);
         DisplayUtil.removeForParent(this.ui);
         this.ui = null;
         for(var i:int = 0; i < 5; i++)
         {
            pp = AimatController.getResEffect(_info.id,"02");
            pp.mouseEnabled = false;
            pp.mouseChildren = false;
            pp.scaleX = pp.scaleY = Math.random();
            pp.alpha = Math.random() + 0.3;
            pp.x = _info.startPos.x;
            pp.y = _info.startPos.y;
            this.arr.push(pp);
            MapManager.currentMap.depthLevel.addChild(pp);
         }
         this.ui2 = AimatController.getResEffect(_info.id,"02");
         this.ui2.x = _info.startPos.x;
         this.ui2.y = _info.startPos.y;
         this.ui2.mouseEnabled = false;
         this.ui2.mouseChildren = false;
         MapManager.currentMap.depthLevel.addChild(this.ui2);
         this.ui2.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onEnter(e:Event) : void
      {
         var k:int = 0;
         var obj:IAimatSprite = null;
         var pp2:MovieClip = null;
         var pp:MovieClip = null;
         if(Math.abs(this.ui2.x - _info.endPos.x) < this._speed / 2 && Math.abs(this.ui2.y - _info.endPos.y) < this._speed / 2)
         {
            this.ui2.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            DisplayUtil.removeForParent(this.ui2);
            this.ui2 = null;
            for(k = 0; k < 5; k++)
            {
               pp2 = this.arr[k];
               DisplayUtil.removeForParent(pp2);
               pp2 = null;
            }
            this.arr = null;
            AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
            obj = MapManager.getObjectPoint(_info.endPos,[IAimatSprite]) as IAimatSprite;
            if(Boolean(obj))
            {
               obj.aimatState(_info);
            }
            return;
         }
         this.ui2.x += this.speedPos.x;
         this.ui2.y += this.speedPos.y;
         for(var j:int = 0; j < 5; j++)
         {
            pp = this.arr[j];
            pp.x += this.speedPos.x + Math.random() * 6 - 3;
            pp.y += this.speedPos.y + (Math.random() * 40 - 20);
         }
      }
   }
}

