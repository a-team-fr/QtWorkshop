/****************************************************************************
**
** Copyright (C) 2013-2015 Oleg Yadrov
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
** http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
**
****************************************************************************/

#include "SyntaxHighlighter.h"

SyntaxHighlighter::SyntaxHighlighter(QObject *parent) :
    QObject(parent),
    m_highlighter(nullptr)
{
    Q_UNUSED(parent)
}

void SyntaxHighlighter::setHighlighter(QObject *textArea)
{
    QQuickTextDocument *quickTextDocument = qvariant_cast<QQuickTextDocument*>(textArea->property("textDocument"));
    QTextDocument *document = quickTextDocument->textDocument();
    m_highlighter = new QMLHighlighter(document);

    m_highlighter->setColor(QMLHighlighter::Normal, m_normalColor);
    m_highlighter->setColor(QMLHighlighter::Comment, m_commentColor);
    m_highlighter->setColor(QMLHighlighter::Number, m_numberColor);
    m_highlighter->setColor(QMLHighlighter::String, m_stringColor);
    m_highlighter->setColor(QMLHighlighter::Operator, m_operatorColor);
    m_highlighter->setColor(QMLHighlighter::Keyword, m_keywordColor);
    m_highlighter->setColor(QMLHighlighter::BuiltIn, m_builtInColor);
    m_highlighter->setColor(QMLHighlighter::Marker, m_markerColor);
    m_highlighter->setColor(QMLHighlighter::Item, m_itemColor);
    m_highlighter->setColor(QMLHighlighter::Property, m_propertyColor);

    m_highlighter->rehighlight();
}

void SyntaxHighlighter::rehighlight() {
    if (m_highlighter)
        m_highlighter->rehighlight();
}

void SyntaxHighlighter::addQmlComponent(QString componentName)
{
    if (m_highlighter)
        m_highlighter->addQmlComponent(componentName);
}

void SyntaxHighlighter::addJsComponent(QString componentName)
{
    if (m_highlighter)
        m_highlighter->addJsComponent(componentName);
}
