import { useState, useEffect } from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { Button } from '@/components/ui/button.jsx'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card.jsx'
import { Input } from '@/components/ui/input.jsx'
import { Badge } from '@/components/ui/badge.jsx'
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog.jsx'
import { Textarea } from '@/components/ui/textarea.jsx'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select.jsx'
import { Label } from '@/components/ui/label.jsx'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs.jsx'
import { 
  Search, 
  Plus, 
  Heart, 
  Calendar, 
  MapPin, 
  Users, 
  BookOpen, 
  Camera, 
  Music, 
  Plane, 
  GraduationCap,
  Star,
  Filter,
  Grid,
  List,
  Moon,
  Sun,
  Settings,
  Download,
  Upload,
  Trash2,
  Edit,
  Eye
} from 'lucide-react'
import './App.css'

// Bengali categories
const categories = [
  { id: 'family', name: 'পরিবার', icon: Heart, color: 'bg-red-100 text-red-800' },
  { id: 'friends', name: 'বন্ধুবান্ধব', icon: Users, color: 'bg-blue-100 text-blue-800' },
  { id: 'travel', name: 'ভ্রমণ', icon: Plane, color: 'bg-green-100 text-green-800' },
  { id: 'education', name: 'শিক্ষা', icon: GraduationCap, color: 'bg-purple-100 text-purple-800' },
  { id: 'work', name: 'কাজ', icon: BookOpen, color: 'bg-orange-100 text-orange-800' },
  { id: 'celebration', name: 'উৎসব', icon: Star, color: 'bg-yellow-100 text-yellow-800' },
  { id: 'hobby', name: 'শখ', icon: Music, color: 'bg-pink-100 text-pink-800' },
  { id: 'special', name: 'বিশেষ মুহূর্ত', icon: Camera, color: 'bg-indigo-100 text-indigo-800' },
  { id: 'achievement', name: 'অর্জন', icon: Star, color: 'bg-emerald-100 text-emerald-800' },
  { id: 'other', name: 'অন্যান্য', icon: MapPin, color: 'bg-gray-100 text-gray-800' }
]

// Sample memories data
const sampleMemories = [
  {
    id: 1,
    title: 'পহেলা বৈশাখ উৎসব',
    description: 'রমনা বটমূলে পহেলা বৈশাখের অনুষ্ঠানে পরিবারের সাথে গিয়েছিলাম। খুব আনন্দের দিন ছিল।',
    category: 'celebration',
    date: '2024-04-14',
    createdAt: '2024-04-14T10:30:00Z',
    image: null,
    audio: null
  },
  {
    id: 2,
    title: 'বিশ্ববিদ্যালয়ের প্রথম দিন',
    description: 'ঢাকা বিশ্ববিদ্যালয়ে ভর্তির প্রথম দিন। নতুন বন্ধুদের সাথে পরিচয়, নতুন পরিবেশ।',
    category: 'education',
    date: '2024-01-15',
    createdAt: '2024-01-15T08:00:00Z',
    image: null,
    audio: null
  },
  {
    id: 3,
    title: 'কক্সবাজার ভ্রমণ',
    description: 'বন্ধুদের সাথে কক্সবাজারে গিয়েছিলাম। সমুদ্র সৈকতে সূর্যাস্ত দেখা, অসাধারণ অভিজ্ঞতা।',
    category: 'travel',
    date: '2024-03-20',
    createdAt: '2024-03-20T18:45:00Z',
    image: null,
    audio: null
  },
  {
    id: 4,
    title: 'মায়ের রান্না',
    description: 'মা আজ আমার প্রিয় খিচুড়ি রান্না করেছেন। ছোটবেলার স্বাদ ফিরে পেলাম।',
    category: 'family',
    date: '2024-06-10',
    createdAt: '2024-06-10T13:20:00Z',
    image: null,
    audio: null
  },
  {
    id: 5,
    title: 'প্রথম চাকরি',
    description: 'আজ প্রথম চাকরিতে যোগদান করলাম। নতুন জীবনের শুরু, অনেক স্বপ্ন নিয়ে।',
    category: 'achievement',
    date: '2024-07-01',
    createdAt: '2024-07-01T09:00:00Z',
    image: null,
    audio: null
  }
]

function App() {
  const [memories, setMemories] = useState(sampleMemories)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedCategory, setSelectedCategory] = useState('all')
  const [viewMode, setViewMode] = useState('grid')
  const [isDarkMode, setIsDarkMode] = useState(false)
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false)
  const [isViewDialogOpen, setIsViewDialogOpen] = useState(false)
  const [selectedMemory, setSelectedMemory] = useState(null)
  const [newMemory, setNewMemory] = useState({
    title: '',
    description: '',
    category: '',
    date: new Date().toISOString().split('T')[0]
  })

  // Filter memories based on search and category
  const filteredMemories = memories.filter(memory => {
    const matchesSearch = memory.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         memory.description.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesCategory = selectedCategory === 'all' || memory.category === selectedCategory
    return matchesSearch && matchesCategory
  })

  // Add new memory
  const handleAddMemory = () => {
    if (newMemory.title && newMemory.description && newMemory.category) {
      const memory = {
        id: Date.now(),
        ...newMemory,
        createdAt: new Date().toISOString(),
        image: null,
        audio: null
      }
      setMemories([memory, ...memories])
      setNewMemory({
        title: '',
        description: '',
        category: '',
        date: new Date().toISOString().split('T')[0]
      })
      setIsAddDialogOpen(false)
    }
  }

  // Delete memory
  const handleDeleteMemory = (id) => {
    setMemories(memories.filter(memory => memory.id !== id))
    setIsViewDialogOpen(false)
  }

  // Export memories as JSON
  const handleExportMemories = () => {
    const dataStr = JSON.stringify(memories, null, 2)
    const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr)
    const exportFileDefaultName = 'smritir-baksho-memories.json'
    
    const linkElement = document.createElement('a')
    linkElement.setAttribute('href', dataUri)
    linkElement.setAttribute('download', exportFileDefaultName)
    linkElement.click()
  }

  // Get category info
  const getCategoryInfo = (categoryId) => {
    return categories.find(cat => cat.id === categoryId) || categories[categories.length - 1]
  }

  // Format date in Bengali
  const formatBengaliDate = (dateString) => {
    const date = new Date(dateString)
    const bengaliMonths = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
    ]
    return `${date.getDate()} ${bengaliMonths[date.getMonth()]}, ${date.getFullYear()}`
  }

  // Toggle dark mode
  useEffect(() => {
    if (isDarkMode) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }, [isDarkMode])

  return (
    <div className="min-h-screen bg-background paper-texture">
      {/* Header */}
      <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-2">
                <Heart className="h-8 w-8 text-primary" />
                <h1 className="text-2xl font-bold bengali-title text-primary">স্মৃতির বাক্স</h1>
              </div>
            </div>
            
            <div className="flex items-center space-x-2">
              <Button
                variant="outline"
                size="icon"
                onClick={() => setIsDarkMode(!isDarkMode)}
                className="vintage-button"
              >
                {isDarkMode ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
              </Button>
              
              <Button
                variant="outline"
                onClick={handleExportMemories}
                className="vintage-button"
              >
                <Download className="h-4 w-4 mr-2" />
                রপ্তানি
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        {/* Search and Filter Section */}
        <div className="mb-8 space-y-4">
          <div className="flex flex-col md:flex-row gap-4">
            {/* Search */}
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                <Input
                  placeholder="স্মৃতি খুঁজুন..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10 search-input bengali-text"
                />
              </div>
            </div>
            
            {/* Category Filter */}
            <Select value={selectedCategory} onValueChange={setSelectedCategory}>
              <SelectTrigger className="w-full md:w-48 search-input">
                <SelectValue placeholder="বিভাগ নির্বাচন করুন" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">সব বিভাগ</SelectItem>
                {categories.map(category => (
                  <SelectItem key={category.id} value={category.id}>
                    {category.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            
            {/* View Mode Toggle */}
            <div className="flex border rounded-lg">
              <Button
                variant={viewMode === 'grid' ? 'default' : 'ghost'}
                size="sm"
                onClick={() => setViewMode('grid')}
                className="rounded-r-none"
              >
                <Grid className="h-4 w-4" />
              </Button>
              <Button
                variant={viewMode === 'list' ? 'default' : 'ghost'}
                size="sm"
                onClick={() => setViewMode('list')}
                className="rounded-l-none"
              >
                <List className="h-4 w-4" />
              </Button>
            </div>
          </div>
          
          {/* Add Memory Button */}
          <div className="flex justify-center">
            <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
              <DialogTrigger asChild>
                <Button className="vintage-button">
                  <Plus className="h-4 w-4 mr-2" />
                  নতুন স্মৃতি যোগ করুন
                </Button>
              </DialogTrigger>
              <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                  <DialogTitle className="bengali-title">নতুন স্মৃতি যোগ করুন</DialogTitle>
                  <DialogDescription className="bengali-text">
                    আপনার প্রিয় মুহূর্তটি সংরক্ষণ করুন
                  </DialogDescription>
                </DialogHeader>
                <div className="grid gap-4 py-4">
                  <div className="grid gap-2">
                    <Label htmlFor="title" className="bengali-text">শিরোনাম</Label>
                    <Input
                      id="title"
                      value={newMemory.title}
                      onChange={(e) => setNewMemory({...newMemory, title: e.target.value})}
                      placeholder="স্মৃতির শিরোনাম লিখুন"
                      className="bengali-text"
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="description" className="bengali-text">বিবরণ</Label>
                    <Textarea
                      id="description"
                      value={newMemory.description}
                      onChange={(e) => setNewMemory({...newMemory, description: e.target.value})}
                      placeholder="স্মৃতির বিস্তারিত লিখুন"
                      className="bengali-text"
                      rows={4}
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="category" className="bengali-text">বিভাগ</Label>
                    <Select value={newMemory.category} onValueChange={(value) => setNewMemory({...newMemory, category: value})}>
                      <SelectTrigger>
                        <SelectValue placeholder="বিভাগ নির্বাচন করুন" />
                      </SelectTrigger>
                      <SelectContent>
                        {categories.map(category => (
                          <SelectItem key={category.id} value={category.id}>
                            {category.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="date" className="bengali-text">তারিখ</Label>
                    <Input
                      id="date"
                      type="date"
                      value={newMemory.date}
                      onChange={(e) => setNewMemory({...newMemory, date: e.target.value})}
                    />
                  </div>
                </div>
                <div className="flex justify-end space-x-2">
                  <Button variant="outline" onClick={() => setIsAddDialogOpen(false)}>
                    বাতিল
                  </Button>
                  <Button onClick={handleAddMemory} className="vintage-button">
                    সংরক্ষণ করুন
                  </Button>
                </div>
              </DialogContent>
            </Dialog>
          </div>
        </div>

        {/* Memories Grid/List */}
        <div className={`${viewMode === 'grid' ? 'memory-grid grid gap-6' : 'space-y-4'}`}>
          {filteredMemories.length === 0 ? (
            <div className="col-span-full text-center py-12">
              <Heart className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
              <h3 className="text-lg font-semibold bengali-title mb-2">কোন স্মৃতি পাওয়া যায়নি</h3>
              <p className="text-muted-foreground bengali-text">নতুন স্মৃতি যোগ করুন বা অনুসন্ধান পরিবর্তন করুন</p>
            </div>
          ) : (
            filteredMemories.map(memory => {
              const categoryInfo = getCategoryInfo(memory.category)
              const IconComponent = categoryInfo.icon
              
              return (
                <Card key={memory.id} className="memory-card fade-in cursor-pointer" onClick={() => {
                  setSelectedMemory(memory)
                  setIsViewDialogOpen(true)
                }}>
                  <CardHeader className="pb-3">
                    <div className="flex items-start justify-between">
                      <div className="flex items-center space-x-2">
                        <IconComponent className="h-5 w-5 text-primary" />
                        <Badge className={`category-badge ${categoryInfo.color}`}>
                          {categoryInfo.name}
                        </Badge>
                      </div>
                      <span className="text-sm text-muted-foreground">
                        {formatBengaliDate(memory.date)}
                      </span>
                    </div>
                    <CardTitle className="bengali-title text-lg">{memory.title}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-muted-foreground bengali-text line-clamp-3">
                      {memory.description}
                    </p>
                  </CardContent>
                </Card>
              )
            })
          )}
        </div>

        {/* View Memory Dialog */}
        <Dialog open={isViewDialogOpen} onOpenChange={setIsViewDialogOpen}>
          <DialogContent className="sm:max-w-[600px]">
            {selectedMemory && (
              <>
                <DialogHeader>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2">
                      {(() => {
                        const categoryInfo = getCategoryInfo(selectedMemory.category)
                        const IconComponent = categoryInfo.icon
                        return <IconComponent className="h-5 w-5 text-primary" />
                      })()}
                      <Badge className={`category-badge ${getCategoryInfo(selectedMemory.category).color}`}>
                        {getCategoryInfo(selectedMemory.category).name}
                      </Badge>
                    </div>
                    <span className="text-sm text-muted-foreground">
                      {formatBengaliDate(selectedMemory.date)}
                    </span>
                  </div>
                  <DialogTitle className="bengali-title text-xl">{selectedMemory.title}</DialogTitle>
                </DialogHeader>
                <div className="py-4">
                  <p className="text-foreground bengali-text leading-relaxed">
                    {selectedMemory.description}
                  </p>
                </div>
                <div className="flex justify-end space-x-2">
                  <Button
                    variant="outline"
                    onClick={() => handleDeleteMemory(selectedMemory.id)}
                    className="text-destructive hover:text-destructive"
                  >
                    <Trash2 className="h-4 w-4 mr-2" />
                    মুছে ফেলুন
                  </Button>
                  <Button variant="outline" onClick={() => setIsViewDialogOpen(false)}>
                    বন্ধ করুন
                  </Button>
                </div>
              </>
            )}
          </DialogContent>
        </Dialog>
      </main>

      {/* Footer */}
      <footer className="border-t bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 mt-16">
        <div className="container mx-auto px-4 py-8">
          <div className="text-center">
            <p className="text-muted-foreground bengali-text">
              © ২০২৪ স্মৃতির বাক্স - আপনার প্রিয় মুহূর্তগুলো চিরকালের জন্য সংরক্ষণ করুন
            </p>
            <p className="text-sm text-muted-foreground mt-2">
              Made with ❤️ for preserving beautiful memories
            </p>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default App

