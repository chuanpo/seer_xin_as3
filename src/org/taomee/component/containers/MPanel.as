package org.taomee.component.containers
{
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.component.Container;
   import org.taomee.component.UIComponent;
   import org.taomee.component.bgFill.IBgFillStyle;
   import org.taomee.component.event.MEvent;
   import org.taomee.component.layout.FlowWarpLayout;
   import org.taomee.component.layout.ILayoutManager;
   import org.taomee.component.manager.MComponentManager;
   
   [Event(name="panelClosed",type="org.taomee.component.event.MEvent")]
   public class MPanel extends Container
   {
      private static var TOP_MARGIN:int = 50;
      
      private static var LEFT_MARGIN:int = 32;
      
      private static var BOTTOM_MARGIN:int = 22;
      
      private static var RIGHT_MARGIN:int = 32;
      
      //[Embed(source="../resource/componentUI.swf",symbol="frame_drag_bar")]
      private var dragBarClass:Class = MPanel_dragBarClass;
      
      private var closeBtn:SimpleButton;
      
      private var box:Container;
      
      //[Embed(source="../resource/componentUI.swf",symbol="frame_close_btn")]
      private var closeBtnClass:Class = MPanel_closeBtnClass;
      
      private var owner:DisplayObjectContainer;
      
      private var titleBar:Sprite;
      
      //[Embed(source="../resource/componentUI.swf",symbol="frame_title_bar")]
      private var titleBarClass:Class = MPanel_titleBarClass;
      
      private var isShowClose:Boolean;
      
      private var frameBG:Sprite;
      
      //[Embed(source="../resource/componentUI.swf",symbol="frame_bg")]
      private var bgClass:Class = MPanel_bgClass;
      
      private var dragBar:SimpleButton;
      
      public function MPanel(isShowClose:Boolean = true, owner:DisplayObjectContainer = null)
      {
         super();
         this.owner = owner;
         this.isShowClose = isShowClose;
         box = new Container();
         box.x = LEFT_MARGIN;
         box.y = TOP_MARGIN;
         box.mouseEnabled = false;
         frameBG = new bgClass() as Sprite;
         frameBG.width = this.width;
         frameBG.height = this.height;
         frameBG.cacheAsBitmap = true;
         closeBtn = new closeBtnClass() as SimpleButton;
         closeBtn.tabEnabled = false;
         closeBtn.cacheAsBitmap = true;
         titleBar = new titleBarClass() as Sprite;
         titleBar.mouseEnabled = false;
         titleBar.y = 15;
         titleBar.cacheAsBitmap = true;
         dragBar = new dragBarClass() as SimpleButton;
         dragBar.alpha = 0;
         dragBar.cacheAsBitmap = true;
         addChild(frameBG);
         addChild(titleBar);
         addChild(box);
         addChild(dragBar);
         if(this.isShowClose)
         {
            addChild(closeBtn);
         }
         setCloseBtnPosition();
         dragBar.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         dragBar.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
         layout = new FlowWarpLayout();
      }
      
      public function hide() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override public function destroy() : void
      {
         titleBar = null;
         dragBar.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         dragBar.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         dragBar = null;
         removeChild(frameBG);
         frameBG.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         frameBG.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         frameBG = null;
         removeChild(box);
         box.destroy();
         box = null;
         owner = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(isShowClose)
         {
            removeChild(closeBtn);
         }
         closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
         closeBtn = null;
         super.destroy();
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      private function setCloseBtnPosition() : void
      {
         titleBar.x = (this.width - titleBar.width) / 2;
         closeBtn.x = this.width - closeBtn.width - 16;
         closeBtn.y = 5;
      }
      
      public function getContentPanel() : Container
      {
         return box;
      }
      
      override public function set bgFillStyle(bgFillStyle:IBgFillStyle) : void
      {
         box.bgFillStyle = bgFillStyle;
      }
      
      override protected function revalidate() : void
      {
         dragBar.width = this.width;
         frameBG.width = this.width;
         frameBG.height = this.height;
         box.width = this.width - LEFT_MARGIN - RIGHT_MARGIN - 3;
         box.height = this.height - TOP_MARGIN - BOTTOM_MARGIN - 4;
         setCloseBtnPosition();
         super.revalidate();
      }
      
      override public function append(comp:UIComponent) : void
      {
         box.append(comp);
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         hide();
         dispatchEvent(new MEvent(MEvent.PANEL_CLOSED));
      }
      
      override public function set layout(layout:ILayoutManager) : void
      {
         box.layout = layout;
      }
      
      override public function appendAll(... comps) : void
      {
         var i:UIComponent = null;
         for each(i in comps)
         {
            box.append(i);
         }
      }
      
      override public function get layout() : ILayoutManager
      {
         return box.layout;
      }
      
      override public function appendAt(comp:UIComponent, index:int) : void
      {
         box.appendAt(comp,index);
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         this.startDrag();
      }
      
      public function show() : void
      {
         if(Boolean(owner))
         {
            owner.addChild(this);
         }
         else
         {
            MComponentManager.root.addChild(this);
         }
      }
   }
}

