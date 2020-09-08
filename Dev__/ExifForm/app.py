import os
from flask import Flask, render_template, flash, redirect, url_for, session, request, logging
from werkzeug.utils import secure_filename
import exiftool
import simplejson

UPLOAD_FOLDER = 'uploads/'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'mov'}
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def root():
    return render_template('base.html')

@app.route('/Form', methods=['POST'])
def form():
    if request.method == 'POST':
        f = request.files['file']
        f.save('uploads/'+ secure_filename(f.filename))
        with exiftool.ExifTool() as et:
            metadata = et.get_metadata('uploads/'+ secure_filename(f.filename))
        return render_template('actor.html', metadata=metadata)

@app.route('/Mod', methods=['POST'])
def Mod():
    for item in request.form:
        print(item +'\t'+str(request.form[item])+'\n')
    return "Mod request made"


@app.errorhandler(404)
def page_not_found(error):
    return redirect(url_for('root'))

if __name__ == '__main__':
    app.run(host= '0.0.0.0', debug=True)