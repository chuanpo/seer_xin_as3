package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class CenterLayout extends EmptyLayout implements ILayoutManager
   {
      private static const TYPE:String = "centerLayout";
      
      public function CenterLayout()
      {
         super();
      }
      
      override public function getType() : String
      {
         return TYPE;
      }
      
      override public function doLayout() : void
      {
         var i:UIComponent = null;
         for each(i in container.compList)
         {
            i.x = (container.width - i.width) / 2;
            i.y = (container.height - i.height) / 2;
         }
      }
   }
}

