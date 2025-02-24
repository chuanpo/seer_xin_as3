package org.taomee.component.layout
{
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import org.taomee.component.Container;
   import org.taomee.component.UIComponent;
   import org.taomee.component.event.LayoutEvent;
   
   [Event(name="layoutSetChanged",type="org.taomee.component.event.LayoutEvent")]
   public class EmptyLayout extends EventDispatcher implements ILayoutManager
   {
      private static const TYPE:String = "emptyLayout";
      
      protected var container:Container;
      
      protected var compSprite:Sprite;
      
      public function EmptyLayout()
      {
         super();
      }
      
      protected function broadcast() : void
      {
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_SET_CHANGED));
      }
      
      public function destroy() : void
      {
         container = null;
         compSprite = null;
      }
      
      public function set layoutObj(container:Container) : void
      {
         this.container = container;
         compSprite = container.getContainSprite();
      }
      
      public function removeLayoutComponent(comp:UIComponent) : void
      {
         if(!compSprite.contains(comp))
         {
            throw new Error(comp + "不是" + container + "的子级，不能被移除");
         }
         compSprite.removeChild(comp);
      }
      
      public function getType() : String
      {
         return TYPE;
      }
      
      public function doLayout() : void
      {
      }
      
      public function addLayoutComponent(comp:UIComponent) : void
      {
         compSprite.addChild(comp);
      }
   }
}

