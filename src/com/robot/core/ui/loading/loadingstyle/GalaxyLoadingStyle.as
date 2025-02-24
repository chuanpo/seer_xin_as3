package com.robot.core.ui.loading.loadingstyle
{
   import com.robot.core.manager.LoadingManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class GalaxyLoadingStyle extends EventDispatcher implements ILoadingStyle
   {
      private var mc:MovieClip;
      
      private var parent:DisplayObjectContainer;
      
      private var txt:TextField;
      
      private var title:String;
      
      public function GalaxyLoadingStyle(parentMC:DisplayObjectContainer = null, title:String = "")
      {
         super();
         this.mc = LoadingManager.getMovieClip("galaxy_loading_mc");
         this.parent = parentMC;
         this.txt = this.mc["txt"];
         this.setTitle(title);
         this.show();
      }
      
      public function changePercent(total:Number, loaded:Number) : void
      {
         var p:uint = Math.floor(loaded / total * 100);
         this.txt.text = this.title + " " + p + "%";
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.mc);
         this.mc = null;
         this.parent = null;
      }
      
      public function show() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.addChild(this.mc);
         }
      }
      
      public function close() : void
      {
         DisplayUtil.removeForParent(this.mc);
      }
      
      public function setTitle(str:String) : void
      {
         this.title = str;
      }
      
      public function setIsShowCloseBtn(i:Boolean) : void
      {
      }
      
      public function getParentMC() : DisplayObjectContainer
      {
         return this.parent;
      }
      
      public function getLoadingMC() : DisplayObject
      {
         return this.mc;
      }
   }
}

