import boundingbox as bb
import math

class QuadTree:
	"""
	The QuadTree class is a tree data structure in which each internal
	non leave node has exactly four children.
	
	the internal data structre `self.quads = {}` is a dictionary where its
	keys represent depth (starting from 0) and has a list of BoundingBoxes representing
	the partions/space. The total area of at each level should remain equal to the initial
	bounding box.
	
	self.quads = 
	{
		0: [1    x BoundingBox ]
		1: [4    x BoundingBox ]
		.. 
		n: [4**n x BoundingBox ]
	}
	
	Generation of the QuadTree is slow, using it to reduce your dataset it fast.

	"""
	def __init__(self,bbox, depth):
		"""
		Create a new QuadTree instance.
		:param bbox: the initial BoundingBox
		:param depth: the depth of the QuadTree

		:Example:
		>>> bbox = bb.BoundingBox(2,9,1,7)
		>>> qt = QuadTree(bbox, 2)
		"""
		self.quads = {}
		self.depth = depth

		for x in range(depth):
			self.quads[x]= []

		self.quads[0] = [bbox]
		self.recurse(bbox, 1)

	def recurse(self,bbox, depth):
		"""
		Internal function called on class contruction, this should 
		create the BoundingBoxes.

		:param bbox: the initial BoundingBox
		:param depth: the depth of the QuadTree

		:To be implemented by the student:		
		"""
		
		if depth >= self.depth:
			return
		centroid = bbox.centroid()
		initbox = bbox.data
		topright = bb.BoundingBox(centroid[0],initbox[0,1],centroid[1],initbox[1,1])
		
		topleft = bb.BoundingBox(initbox[0,0],centroid[0],centroid[1],initbox[1,1])
		
		botright= bb.BoundingBox(centroid[0],initbox[0,1],initbox[1,0],centroid[1])
		
		botleft= bb.BoundingBox(initbox[0,0],centroid[0],initbox[1,0],centroid[1])
		
		# self.quads[depth] = [topright, topleft,botleft,botright]
		self.quads[depth] += [topright]
		self.quads[depth] += [topleft]
		self.quads[depth] += [botleft]
		self.quads[depth] += [botright]
		
		depth = depth +1
		self.recurse(topright, depth)
		self.recurse(topleft, depth)
		self.recurse(botright, depth)
		self.recurse(botleft, depth)
		

	@staticmethod	
	def at_least(size):
		"""
		Returns the amount of BoundingBoxes when the user
		request `at least` an amount of bboxes. The returned
		value is >= than size.
		
		:param size: minimum requested size

		:Example:
		>>> print(QuadTree.at_least(900))
		>>> 1024	
		"""
		return 4**int(math.ceil(math.log(size,4)))

	@staticmethod	
	def at_most(size):
		"""
		Returns the amount of BoundingBoxes when the user
		request `at most` an amount of bboxes. The returned
		value is <= than size.
		
		:param size: maximum requested size

		:Example:
		>>> print(QuadTree.at_most(900))
		>>> 256
		"""
		return 4**int(math.floor(math.log(size,4)))

	@staticmethod	
	def level(size):
		"""
		Returns the level required (rounded up)
		for a given size of elements. 
		return int(math.ceil(math.log(size,4)))
	
		:param size: requested size
		>>> print(QuadTree.level(1))
		>>> 0
		>>> print(QuadTree.level(5))
		>>> 2
		"""
		return int(math.ceil(math.log(size,4)))

	def quadrants(self):
		"""
		Returns the quads member
		"""
		return self.quads

if __name__ == '__main__':

	bbox = bb.BoundingBox(2,9,1,7)
	print(QuadTree.at_least(900))
	print(QuadTree.at_most(900))
	print(QuadTree.level(1))
	print(QuadTree.level(5))
	print(QuadTree.level(900))

	qt = QuadTree(bbox, 3)
	for k,v in qt.quads.items():
		print (k,len(v))
		for x in v:
			print(x.data)

