import os
from flask import Flask, render_template, flash, redirect, url_for, session, request, logging
from werkzeug.utils import secure_filename
import exiftool

UPLOAD_FOLDER = 'uploads/'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def root():
    return render_template('base.html')

@app.route('/Form', methods=['GET', 'POST'])
def form():
    if request.method == 'POST':
        f = request.files['file']
        f.save('uploads/'+ secure_filename(f.filename))
        meta = exiftool.ExifTool().get_metadata(f.filename)
        print(str(f.filename))
        #return 'file uploaded successfully'
        return render_template('actor.html')

@app.errorhandler(404)
def page_not_found(error):
    return redirect(url_for('root'))

if __name__ == '__main__':
    app.run(host= '0.0.0.0', debug=True)