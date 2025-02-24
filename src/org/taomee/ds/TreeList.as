package org.taomee.ds
{
   public class TreeList implements ITree
   {
      private var _root:TreeList;
      
      private var _data:*;
      
      private var _parent:TreeList;
      
      private var _children:Array;
      
      public function TreeList(data:* = null, parent:TreeList = null)
      {
         super();
         _data = data;
         _children = [];
         this.parent = parent;
      }
      
      public function get depth() : int
      {
         if(_parent == null)
         {
            return 0;
         }
         var node:TreeList = _parent;
         var c:int = 0;
         while(Boolean(node))
         {
            c++;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeList Infinite Loop");
            }
         }
         return c;
      }
      
      public function remove() : void
      {
         var child:TreeList = null;
         if(_parent == null)
         {
            return;
         }
         for each(child in _children)
         {
            child.parent = _parent;
         }
      }
      
      public function clear() : void
      {
         _children = [];
      }
      
      public function set data(d:*) : void
      {
         _data = d;
      }
      
      public function get numSiblings() : int
      {
         if(Boolean(_parent))
         {
            return _parent.numChildren;
         }
         return 0;
      }
      
      public function get root() : TreeList
      {
         return _root;
      }
      
      public function set parent(parent:TreeList) : void
      {
         var index:int = 0;
         if(Boolean(_parent))
         {
            index = int(_parent.children.indexOf(this));
            if(index != -1)
            {
               _parent.children.splice(index,1);
            }
         }
         if(parent == this)
         {
            return;
         }
         _parent = parent;
         if(Boolean(_parent))
         {
            _parent.children.push(this);
         }
         setRoot();
      }
      
      private function setRoot() : void
      {
         if(_parent == null)
         {
            _root = this;
            return;
         }
         var node:TreeList = _parent;
         while(Boolean(node))
         {
            if(node.parent == null)
            {
               _root = node;
               return;
            }
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeList Infinite Loop");
            }
         }
      }
      
      public function get length() : int
      {
         var c:int = numChildren;
         var node:TreeList = _parent;
         while(Boolean(node))
         {
            c += node.numChildren;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeList Infinite Loop");
            }
         }
         return c;
      }
      
      public function get isLeaf() : Boolean
      {
         return _children.length == 0;
      }
      
      public function get data() : *
      {
         return _data;
      }
      
      public function get isRoot() : Boolean
      {
         return _root == this;
      }
      
      public function get numChildren() : int
      {
         return _children.length;
      }
      
      public function get parent() : TreeList
      {
         return _parent;
      }
      
      public function get children() : Array
      {
         return _children;
      }
   }
}

