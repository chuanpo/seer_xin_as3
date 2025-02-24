package org.taomee.component
{
   import flash.display.Sprite;
   import org.taomee.component.event.ContainerEvent;
   import org.taomee.component.event.LayoutEvent;
   import org.taomee.component.geom.IntDimension;
   import org.taomee.component.layout.EmptyLayout;
   import org.taomee.component.layout.ILayoutManager;
   
   [Event(name="compRemoved",type="org.taomee.component.event.ContainerEvent")]
   [Event(name="compAdded",type="org.taomee.component.event.ContainerEvent")]
   public class Container extends UIComponent
   {
      protected var layoutManager:ILayoutManager;
      
      private var isUpdating:Boolean = false;
      
      public function Container()
      {
         super();
         layoutManager = new EmptyLayout();
         layoutManager.addEventListener(LayoutEvent.LAYOUT_SET_CHANGED,layoutChanged);
         initLayout();
      }
      
      public function append(comp:UIComponent) : void
      {
         layoutManager.addLayoutComponent(comp);
         containSprite.addChild(comp);
         layoutManager.doLayout();
         dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,comp));
      }
      
      public function remove(comp:UIComponent) : void
      {
         layoutManager.removeLayoutComponent(comp);
         comp.destroy();
         layoutManager.doLayout();
         dispatchEvent(new ContainerEvent(ContainerEvent.COMP_REMOVED,comp));
      }
      
      public function appendAll(... comps) : void
      {
         var i:UIComponent = null;
         for each(i in comps)
         {
            layoutManager.addLayoutComponent(i);
            containSprite.addChild(i);
            dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,i));
         }
         layoutManager.doLayout();
      }
      
      override protected function revalidate() : void
      {
         if(isUpdating)
         {
            return;
         }
         super.revalidate();
         isUpdating = true;
         initLayout();
      }
      
      private function layoutChanged(event:LayoutEvent) : void
      {
         initLayout();
      }
      
      public function set layout(layout:ILayoutManager) : void
      {
         if(Boolean(layoutManager))
         {
            layoutManager.removeEventListener(LayoutEvent.LAYOUT_SET_CHANGED,layoutChanged);
            layoutManager.destroy();
         }
         if(!layout)
         {
            layout = new EmptyLayout();
         }
         layoutManager = layout;
         layoutManager.addEventListener(LayoutEvent.LAYOUT_SET_CHANGED,layoutChanged);
         initLayout();
      }
      
      public function appendAt(comp:UIComponent, index:int) : void
      {
         containSprite.addChildAt(comp,index);
         layoutManager.doLayout();
         dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,comp));
      }
      
      public function get layout() : ILayoutManager
      {
         return layoutManager;
      }
      
      protected function initLayout() : void
      {
         layoutManager.layoutObj = this;
         layoutManager.doLayout();
         isUpdating = false;
      }
      
      public function get compList() : Array
      {
         var arr:Array = [];
         var count:uint = 0;
         while(count < containSprite.numChildren)
         {
            arr.push(containSprite.getChildAt(count));
            count++;
         }
         return arr;
      }
      
      override public function destroy() : void
      {
         trace("container destroy");
         layoutManager.removeEventListener(LayoutEvent.LAYOUT_SET_CHANGED,layoutChanged);
         layoutManager.destroy();
         layoutManager = null;
         super.destroy();
      }
      
      public function getContainSprite() : Sprite
      {
         return containSprite;
      }
      
      public function get contentSize() : IntDimension
      {
         return new IntDimension(containSprite.width,containSprite.height);
      }
      
      public function removeAll() : void
      {
         var mc:UIComponent = null;
         while(containSprite.numChildren > 0)
         {
            mc = containSprite.getChildAt(0) as UIComponent;
            layoutManager.removeLayoutComponent(mc);
            mc.destroy();
            dispatchEvent(new ContainerEvent(ContainerEvent.COMP_REMOVED,mc));
         }
      }
   }
}

