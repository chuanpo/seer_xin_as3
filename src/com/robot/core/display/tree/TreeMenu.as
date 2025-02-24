package com.robot.core.display.tree
{
   import com.robot.core.manager.TasksManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TreeMenu extends Sprite
   {
      private var _tree:Tree;
      
      private var _btnArr:Array;
      
      private var _display:Sprite;
      
      private var _itemname:String = "";
      
      private var _clickBtnY:Number = 0;
      
      public function TreeMenu(tree:Tree)
      {
         super();
         this._tree = tree;
         this._display = new Sprite();
         this.addChild(this._display);
         this.renderTree();
      }
      
      private function renderTree(nodeName:String = "") : void
      {
         var node:StatefulNode = null;
         var addGlow:Boolean = false;
         var item:MovieClip = null;
         var btn:Btn = null;
         this._btnArr = new Array();
         var arr:Array = this._tree.toArray();
         var lastY:uint = 0;
         for each(node in arr)
         {
            if(node.isOpen() && node != this._tree.root)
            {
               addGlow = false;
               if(node.hasIsNewAndUNChilds() && !node.isClick)
               {
                  addGlow = true;
               }
               item = TreeItem.createItem(node.data,addGlow);
               btn = new Btn(node.name,item,node);
               btn.addEventListener(MouseEvent.CLICK,this.onRelease);
               if(node.layer == 1)
               {
                  btn.display.x = 10;
               }
               btn.display.y = lastY;
               trace(btn.display.x + "  " + btn.display.y);
               this._display.addChild(btn.display);
               lastY = btn.display.y + btn.display.height + 2;
               this._btnArr.push(btn);
            }
            if(node.name == nodeName)
            {
               this._clickBtnY = lastY;
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onRelease(e:MouseEvent) : void
      {
         this.select((e.target as Btn).nameID);
         if(this._itemname == (e.target as Btn).nameID)
         {
            return;
         }
         this._itemname = (e.target as Btn).nameID;
         dispatchEvent(new ItemClickEvent(e.target as Btn,ItemClickEvent.ITEMCLICK));
      }
      
      public function select(id:String, pageParams:Array = null, changed:Boolean = true) : void
      {
         var n:StatefulNode = null;
         var n1:StatefulNode = null;
         var child:StatefulNode = null;
         var node:StatefulNode = Tree.getNodeByNameID(id,this._tree.root) as StatefulNode;
         if(node == null)
         {
            return;
         }
         node.isClick = true;
         for each(n in node.children)
         {
            for each(n1 in n.children)
            {
               if(n1.data.newOnline == "1")
               {
                  if(TasksManager.getTaskStatus(n1.data.id) == TasksManager.UN_ACCEPT)
                  {
                     n1.isNewAndUN = true;
                  }
               }
            }
         }
         if(!node.hasOpenChilds())
         {
            for each(child in node.children)
            {
               child.setOpen(true);
               this.openClosedNodes(child);
            }
            node.setOpen(true);
            this.openParents(node);
         }
         else
         {
            this.closeChildren(node);
         }
         this.finishTree();
         this.renderTree(node.name);
         this.markButton(node.name);
      }
      
      public function finishTree() : void
      {
         this._clickBtnY = 0;
         while(this._display.numChildren > 0)
         {
            this._display.removeChildAt(0);
         }
      }
      
      private function markButton(name:String) : void
      {
         var btn:Btn = null;
         for each(btn in this._btnArr)
         {
            if(btn.nameID == name)
            {
               btn.mark();
            }
            else
            {
               btn.unmark();
            }
         }
      }
      
      private function closeBrotherNodesChildren(node:StatefulNode, brother:StatefulNode) : void
      {
         if(node.name != brother.name)
         {
            this.closeChildren(brother);
         }
      }
      
      private function openClosedNodes(node:StatefulNode) : void
      {
         var child:StatefulNode = null;
         for each(child in node.children)
         {
            if(child.isClosed())
            {
               child.setOpen(true);
               this.openClosedNodes(child);
            }
         }
      }
      
      private function closeChildren(node:StatefulNode) : void
      {
         var child:StatefulNode = null;
         for each(child in node.children)
         {
            if(child.isOpen())
            {
               child.setClosed(true);
            }
            else
            {
               child.setClosed(false);
            }
            child.setOpen(false);
            this.closeChildren(child);
         }
      }
      
      private function openParents(node:StatefulNode) : void
      {
         var child:StatefulNode = null;
         var parent:StatefulNode = node.parent as StatefulNode;
         if(Boolean(parent))
         {
            parent.setOpen(true);
            for each(child in parent.children)
            {
               child.setOpen(true);
               this.closeBrotherNodesChildren(node,child);
            }
            this.openParents(parent);
         }
         else
         {
            node.setOpen(true);
         }
      }
      
      public function finalize() : void
      {
         this.finishTree();
         this._tree.finalize();
      }
      
      public function get display() : DisplayObject
      {
         return this._display;
      }
      
      public function getItemCount() : uint
      {
         return this._btnArr.length;
      }
      
      public function getClickBtnY() : Number
      {
         return this._clickBtnY;
      }
   }
}

