from flask import Flask, render_template, flash, redirect, url_for, session, request, logging
from passlib.hash import sha256_crypt
import methods
app = Flask(__name__)

@app.route('/')
def root():
    return render_template('base.html')

@app.route('/scan/')
def index():
    return redirect(url_for('root'))

@app.route('/scan/<string:ip>/')
def actor(ip):
    Alive = False
    if methods.isValid(ip):
        if methods.isAlive(ip):
            Alive = True
            NmapResult=methods.nmapPortScan(ip)
        return render_template('actor.html', Alive=Alive, ip=ip, NmapResult=NmapResult)
    else:
        return redirect(url_for('root'))

@app.errorhandler(404)
def page_not_found(error):
    return redirect(url_for('root'))

if __name__ == '__main__':
    app.run(host= '0.0.0.0', debug=True)