const express = require('express');
const multer = require('multer');
const path = require('path');

const app = express();
const port = 3000;

// Multer setup
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});
const upload = multer({ storage: storage });

// Static file serving for public folder
app.use(express.static(path.join(__dirname, 'public')));

// Static file serving for uploaded images
app.use('/uploads', express.static("uploads"));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve index.html at root
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.post('/uploads', upload.single('image'), (req, res) => {
  const { date, location } = req.body;
  const image = req.file;

  console.log('Date:', date);
  console.log('Location:', location);
  console.log('Image:', image);

  if (!image) {
    return res.status(400).send('No image file uploaded.');
  }

  res.send(`Image uploaded: <a href="/uploads/${image.filename}">${image.filename}</a>, Date: ${date}, Location: ${location}`);
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
