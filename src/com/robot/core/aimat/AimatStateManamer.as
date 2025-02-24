package com.robot.core.aimat
{
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.IAimatSprite;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.TickManager;
   import org.taomee.utils.Utils;
   
   public class AimatStateManamer
   {
      private static const PATH:String = "com.robot.app.aimat.state.AimatState_";
      
      private var _list:HashMap = new HashMap();
      
      private var _obj:IAimatSprite;
      
      public function AimatStateManamer(obj:IAimatSprite)
      {
         super();
         this._obj = obj;
         TickManager.addListener(this.loop);
      }
      
      public function execute(info:AimatInfo) : void
      {
         var cls:Class = null;
         var newA:IAimatState = null;
         var old:IAimatState = this._list.remove(info.id);
         if(Boolean(old))
         {
            old.destroy();
            old = null;
         }
         var stageId:uint = AimatXMLInfo.getIsStage(info.id);
         if(stageId != 0)
         {
            cls = Utils.getClass(PATH + stageId);
         }
         else
         {
            cls = Utils.getClass(PATH + info.id.toString());
         }
         if(Boolean(cls))
         {
            newA = new cls();
            this._list.add(info.id,newA);
            newA.execute(this._obj,info);
         }
      }
      
      public function isType(t:uint) : Boolean
      {
         return this._list.containsKey(t);
      }
      
      public function clear() : void
      {
         this._list.eachValue(function(o:IAimatState):void
         {
            o.destroy();
            o = null;
         });
         this._list.clear();
      }
      
      public function destroy() : void
      {
         TickManager.removeListener(this.loop);
         this.clear();
         this._list = null;
         this._obj = null;
      }
      
      private function loop() : void
      {
         if(this._list.isEmpty())
         {
            return;
         }
         this._list.each2(function(id:uint, o:IAimatState):void
         {
            if(o.isFinish)
            {
               _list.remove(id);
               o.destroy();
               o = null;
            }
         });
      }
   }
}

