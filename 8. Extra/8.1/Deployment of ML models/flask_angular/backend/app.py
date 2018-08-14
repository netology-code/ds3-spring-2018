from flask import Flask, request, jsonify
from sklearn import svm
from sklearn import datasets
from sklearn.externals import joblib

HOST = '0.0.0.0'
PORT = 8081

app = Flask(__name__)

@app.route('/api/train', methods=['POST'])
def train():

    parameters = request.get_json()

    iris = datasets.load_iris()
    X, y = iris.data, iris.target

    clf = svm.SVC(C=float(parameters['C']),
                  probability=True,
                  random_state=1)
    clf.fit(X, y)

    joblib.dump(clf, 'model.pkl')

    return jsonify({'accuracy': round(clf.score(X, y) * 100, 2)})


@app.route('/api/predict', methods=['POST'])
def predict():

    X = request.get_json()
    X = [[float(X['sepalLength']), float(X['sepalWidth']), float(X['petalLength']), float(X['petalWidth'])]]

    clf = joblib.load('model.pkl')
    probabilities = clf.predict_proba(X)

    return jsonify([{'name': 'Iris-Setosa', 'value': round(probabilities[0, 0] * 100, 2)},
                    {'name': 'Iris-Versicolour', 'value': round(probabilities[0, 1] * 100, 2)},
                    {'name': 'Iris-Virginica', 'value': round(probabilities[0, 2] * 100, 2)}])


if __name__ == '__main__':

    app.run(host=HOST,
            debug=True,  
            port=PORT)
