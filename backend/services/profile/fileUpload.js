import { Router } from 'express';
import multer from 'multer';

const fileUploadRouter = (firebaseBucket) => {
  const router = Router();
  const storageConfig = multer.memoryStorage();
  const upload = multer({ storage: storageConfig });

  // Handle file uploads
  router.post('/upload/', upload.single('file'), async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({ message: 'No file uploaded' });
      }

      // Retrieve the UID from the request
      const userId = req.headers['x-user-id'];
      const fileBuffer = req.file.buffer;
      const fileName = req.file.originalname;

      // Upload the file to Firebase Storage
      const file = firebaseBucket.file(`profile_images/${userId}/${fileName}`);
      const stream = file.createWriteStream({
        metadata: {
          contentType: req.file.mimetype,
        },
      });

      stream.on('error', (err) => {
        console.error('Error uploading to Firebase Storage:', err);
        return res.status(500).json({ message: 'Failed to upload to Firebase Storage' });
      });

      stream.on('finish', () => {
        console.log('Uploaded to Firebase Storage');
        return res.status(200).json({ message: 'File uploaded successfully' });
      });

      // Ending the stream triggers the 'finish' event
      stream.end(fileBuffer);
    } catch (error) {
      console.error('Error:', error);
      return res.status(500).json({ message: 'Internal server error' });
    }
  });

  return router;
};

export default fileUploadRouter;
